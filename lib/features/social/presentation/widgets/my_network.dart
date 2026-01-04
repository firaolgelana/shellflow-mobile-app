import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_user.dart';
import 'package:shell_flow_mobile_app/features/social/presentation/bloc/social_bloc.dart';

class MyNetwork extends StatefulWidget {
  const MyNetwork({super.key});

  @override
  State<MyNetwork> createState() => _MyNetworkState();
}

class _MyNetworkState extends State<MyNetwork> {
  @override
  void initState() {
    super.initState();
    // Trigger initial fetch of users. 
    // We send an empty query to fetch "all" or "suggested" users (up to the limit defined in datasource).
    context.read<SocialBloc>().add(const SearchUsersEvent(query: ''));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialBloc, SocialState>(
      listener: (context, state) {
        if (state is ConnectionRequestSentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Request sent to ${state.request.requestId}'), // Ideally show name
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is SocialFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      // We check specifically for UserSearchResultsLoaded or Loading, 
      // but we don't want to rebuild the whole page if a different event (like FeedLoaded) triggers.
      // Ideally, use buildWhen, but for this example, standard builder is fine.
      builder: (context, state) {
        List<SocialUser>? users;
        bool isLoading = false;

        if (state is SocialLoading) {
          isLoading = true;
        } else if (state is UserSearchResultsLoaded) {
          users = state.users;
        }
        
        // If we have previous data but are performing an action, keep showing data
        // Only show pure loading if we have nothing.
        if (isLoading && users == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          // Key for NestedScrollView to work
          key: const PageStorageKey<String>('my_network'),
          slivers: [
            // This injects space so the list starts below the AppBar
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            
            if (users != null && users.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final user = users![index];
                      return _UserConnectionCard(user: user);
                    },
                    childCount: users.length,
                  ),
                ),
              )
            else if (!isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: Text('No users found to connect with.'),
                ),
              ),
          ],
        );
      },
    );
  }
}
class _UserConnectionCard extends StatefulWidget {
  final SocialUser user;

  const _UserConnectionCard({required this.user});

  @override
  State<_UserConnectionCard> createState() => _UserConnectionCardState();
}

class _UserConnectionCardState extends State<_UserConnectionCard> {
  bool isRequestSent = false;

  @override
  Widget build(BuildContext context) {
    // 1. SAFE DATA EXTRACTION
    // If username is empty/null, use "User", otherwise use the name
    final displayName = (widget.user.username.isNotEmpty) 
        ? widget.user.username 
        : "Unknown User";
    
    // Get the first letter for the avatar placeholder
    final String initial = displayName.isNotEmpty 
        ? displayName[0].toUpperCase() 
        : "?";

    // 2. CHECK IMAGE VALIDITY
    // It must be NOT null AND NOT empty to use NetworkImage
    final bool hasValidImage = widget.user.photoUrl.isNotEmpty;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // --- AVATAR SECTION ---
            CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              // Only load NetworkImage if URL is valid
              backgroundImage: hasValidImage 
                  ? NetworkImage(widget.user.photoUrl) 
                  : null,
              // If no image, show the Initial (e.g. "F")
              child: !hasValidImage
                  ? Text(
                      initial,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            
            // --- TEXT SECTION ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Suggested for you',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // --- BUTTON SECTION ---
            ElevatedButton(
              onPressed: isRequestSent
                  ? null
                  : () {
                      setState(() {
                        isRequestSent = true;
                      });
                      context.read<SocialBloc>().add(
                            SendConnectionRequestEvent(
                              targetUserId: widget.user.id,
                            ),
                          );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: isRequestSent 
                    ? Colors.grey[300] 
                    : Theme.of(context).colorScheme.primary,
                foregroundColor: isRequestSent 
                    ? Colors.grey 
                    : Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              ),
              child: Text(isRequestSent ? 'Sent' : 'Connect'),
            ),
          ],
        ),
      ),
    );
  }
}