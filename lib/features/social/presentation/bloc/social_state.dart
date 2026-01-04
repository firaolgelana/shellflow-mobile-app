part of 'social_bloc.dart';

abstract class SocialState extends Equatable {
  const SocialState();
  
  @override
  List<Object?> get props => [];
}

class SocialInitial extends SocialState {}

class SocialLoading extends SocialState {}

class SocialFailure extends SocialState {
  final String message;
  const SocialFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// --- Data Loaded States ---

class SocialFeedLoaded extends SocialState {
  final List<SocialTask> tasks;
  const SocialFeedLoaded(this.tasks);
  @override
  List<Object?> get props => [tasks];
}

class TaskCommentsLoaded extends SocialState {
  final List<SocialComment> comments;
  const TaskCommentsLoaded(this.comments);
  @override
  List<Object?> get props => [comments];
}

class FriendListLoaded extends SocialState {
  final List<SocialUser> friends;
  const FriendListLoaded(this.friends);
  @override
  List<Object?> get props => [friends];
}

class PendingRequestsLoaded extends SocialState {
  final List<ConnectionRequest> requests;
  const PendingRequestsLoaded(this.requests);
  @override
  List<Object?> get props => [requests];
}

class UserSearchResultsLoaded extends SocialState {
  final List<SocialUser> users;
  const UserSearchResultsLoaded(this.users);
  @override
  List<Object?> get props => [users];
}

class SocialUserProfileLoaded extends SocialState {
  final UserProfile profile;
  const SocialUserProfileLoaded(this.profile);
  @override
  List<Object?> get props => [profile];
}

class SharedTaskDetailsLoaded extends SocialState {
  final SocialTask task;
  const SharedTaskDetailsLoaded(this.task);
  @override
  List<Object?> get props => [task];
}

// --- Action Success States ---
// These are useful for triggering SnackBars or Navigation

class TaskSharedSuccess extends SocialState {
  final SocialTask task;
  const TaskSharedSuccess(this.task);
}

class CommentAddedSuccess extends SocialState {
  final SocialComment comment;
  const CommentAddedSuccess(this.comment);
}

class ConnectionRequestSentSuccess extends SocialState {
  final ConnectionRequest request;
  const ConnectionRequestSentSuccess(this.request);
}

/// Generic success for actions that return void (Delete, Like, Remove, Handle Request)
class SocialActionSuccess extends SocialState {
  final String message;
  const SocialActionSuccess(this.message);
  @override
  List<Object?> get props => [message];
}