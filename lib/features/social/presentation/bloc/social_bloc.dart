import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// Import your Entities
import 'package:shell_flow_mobile_app/features/profile/domain/entities/user_profile.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/connection_request.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_comment.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_task.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_user.dart';
import 'package:shell_flow_mobile_app/features/social/domain/repositories/social_repository.dart'; // For Action Enum

// Import your 14 Use Cases
import 'package:shell_flow_mobile_app/features/social/domain/usecases/add_comment.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/delete_comment.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/get_friends_list.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/get_pending_requests.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/get_shared_task_details.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/get_social_feed.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/get_social_user_profile.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/get_task_comments.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/handle_connection_request.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/remove_friend.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/search_users.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/send_connection_request.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/share_task_to_feed.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/toggle_like_task.dart';

part 'social_event.dart';
part 'social_state.dart';

class SocialBloc extends Bloc<SocialEvent, SocialState> {
  // UseCases
  final AddComment addComment;
  final DeleteComment deleteComment;
  final GetFriendsList getFriendsList;
  final GetPendingRequests getPendingRequests;
  final GetSharedTaskDetails getSharedTaskDetails;
  final GetSocialFeed getSocialFeed;
  final GetSocialUserProfile getSocialUserProfile;
  final GetTaskComments getTaskComments;
  final HandleConnectionRequest handleConnectionRequest;
  final RemoveFriend removeFriend;
  final SearchUsers searchUsers;
  final SendConnectionRequest sendConnectionRequest;
  final ShareTaskToFeed shareTaskToFeed;
  final ToggleLikeTask toggleLikeTask;

  SocialBloc({
    required this.addComment,
    required this.deleteComment,
    required this.getFriendsList,
    required this.getPendingRequests,
    required this.getSharedTaskDetails,
    required this.getSocialFeed,
    required this.getSocialUserProfile,
    required this.getTaskComments,
    required this.handleConnectionRequest,
    required this.removeFriend,
    required this.searchUsers,
    required this.sendConnectionRequest,
    required this.shareTaskToFeed,
    required this.toggleLikeTask,
  }) : super(SocialInitial()) {
    // Register Handlers
    on<GetSocialFeedEvent>(_onGetSocialFeed);
    on<ShareTaskToFeedEvent>(_onShareTaskToFeed);
    on<ToggleLikeTaskEvent>(_onToggleLikeTask);
    on<GetSharedTaskDetailsEvent>(_onGetSharedTaskDetails);
    
    on<GetTaskCommentsEvent>(_onGetTaskComments);
    on<AddCommentEvent>(_onAddComment);
    on<DeleteCommentEvent>(_onDeleteComment);
    
    on<GetFriendListEvent>(_onGetFriendList);
    on<SearchUsersEvent>(_onSearchUsers);
    on<SendConnectionRequestEvent>(_onSendConnectionRequest);
    on<GetPendingRequestsEvent>(_onGetPendingRequests);
    on<HandleConnectionRequestEvent>(_onHandleConnectionRequest);
    on<RemoveFriendEvent>(_onRemoveFriend);
    
    on<GetSocialUserProfileEvent>(_onGetSocialUserProfile);
  }

  // --- Handlers ---

  Future<void> _onGetSocialFeed(
    GetSocialFeedEvent event,
    Emitter<SocialState> emit,
  ) async {
    emit(SocialLoading());
    // Assuming GetSocialFeed usecase takes a Params class or named args
    // Adjust based on your actual Usecase `call` definition
    final result = await getSocialFeed();
    result.fold(
      (failure) => emit(SocialFailure(failure.message)),
      (feed) => emit(SocialFeedLoaded(feed)),
    );
  }

  Future<void> _onShareTaskToFeed(
    ShareTaskToFeedEvent event,
    Emitter<SocialState> emit,
  ) async {
    emit(SocialLoading());
    final result = await shareTaskToFeed(event.taskId);
    result.fold(
      (failure) => emit(SocialFailure(failure.message)),
      (task) => emit(TaskSharedSuccess(task)),
    );
  }

  Future<void> _onToggleLikeTask(
    ToggleLikeTaskEvent event,
    Emitter<SocialState> emit,
  ) async {
    // Note: Ideally, for likes, you might want optimistic UI updates, 
    // but here we stick to the clean architecture flow.
    final result = await toggleLikeTask(event.taskId);
    result.fold(
      (failure) => emit(SocialFailure(failure.message)),
      (_) => emit(const SocialActionSuccess("Like toggled")),
    );
  }

  Future<void> _onGetSharedTaskDetails(
      GetSharedTaskDetailsEvent event, Emitter<SocialState> emit) async {
    emit(SocialLoading());
    final result = await getSharedTaskDetails(event.taskId);
    result.fold(
      (failure) => emit(SocialFailure(failure.message)),
      (task) => emit(SharedTaskDetailsLoaded(task)),
    );
  }

  Future<void> _onGetTaskComments(
      GetTaskCommentsEvent event, Emitter<SocialState> emit) async {
    emit(SocialLoading());
    final result = await getTaskComments(event.taskId);
    result.fold(
      (failure) => emit(SocialFailure(failure.message)),
      (comments) => emit(TaskCommentsLoaded(comments)),
    );
  }

  Future<void> _onAddComment(
      AddCommentEvent event, Emitter<SocialState> emit) async {
    // Note: Do NOT emit Loading here if you want to keep the comments visible while adding.
    // Instead, you might manage loading state locally in UI or use a specific `CommentAdding` state.
    // For now, we follow standard flow:
    final result = await addComment(event.taskId, event.content);
    result.fold(
      (failure) => emit(SocialFailure(failure.message)),
      (comment) => emit(CommentAddedSuccess(comment)),
    );
  }

  Future<void> _onDeleteComment(
      DeleteCommentEvent event, Emitter<SocialState> emit) async {
    final result = await deleteComment(event.commentId);
    result.fold(
      (failure) => emit(SocialFailure(failure.message)),
      (_) => emit(const SocialActionSuccess("Comment deleted")),
    );
  }

  Future<void> _onGetFriendList(
      GetFriendListEvent event, Emitter<SocialState> emit) async {
    emit(SocialLoading());
    final result = await getFriendsList();
    result.fold(
      (failure) => emit(SocialFailure(failure.message)),
      (friends) => emit(FriendListLoaded(friends)),
    );
  }

  Future<void> _onSearchUsers(
      SearchUsersEvent event, Emitter<SocialState> emit) async {
    emit(SocialLoading());
    final result = await searchUsers(event.query);
    result.fold(
      (failure) => emit(SocialFailure(failure.message)),
      (users) => emit(UserSearchResultsLoaded(users)),
    );
  }

  Future<void> _onSendConnectionRequest(
      SendConnectionRequestEvent event, Emitter<SocialState> emit) async {
    emit(SocialLoading());
    final result = await sendConnectionRequest(event.targetUserId);
    result.fold(
      (failure) => emit(SocialFailure(failure.message)),
      (request) => emit(ConnectionRequestSentSuccess(request)),
    );
  }

  Future<void> _onGetPendingRequests(
      GetPendingRequestsEvent event, Emitter<SocialState> emit) async {
    emit(SocialLoading());
    final result = await getPendingRequests();
    result.fold(
      (failure) => emit(SocialFailure(failure.message)),
      (requests) => emit(PendingRequestsLoaded(requests)),
    );
  }

  Future<void> _onHandleConnectionRequest(
      HandleConnectionRequestEvent event, Emitter<SocialState> emit) async {
    final result = await handleConnectionRequest(event.requestId, event.action);
    result.fold(
      (failure) => emit(SocialFailure(failure.message)),
      (_) => emit(const SocialActionSuccess("Request updated")),
    );
  }

  Future<void> _onRemoveFriend(
      RemoveFriendEvent event, Emitter<SocialState> emit) async {
    final result = await removeFriend(event.friendId);
    result.fold(
      (failure) => emit(SocialFailure(failure.message)),
      (_) => emit(const SocialActionSuccess("Friend removed")),
    );
  }

  Future<void> _onGetSocialUserProfile(
      GetSocialUserProfileEvent event, Emitter<SocialState> emit) async {
    emit(SocialLoading());
    final result = await getSocialUserProfile(event.userId);
    result.fold(
      (failure) => emit(SocialFailure(failure.message)),
      (profile) => emit(SocialUserProfileLoaded(profile)),
    );
  }
}