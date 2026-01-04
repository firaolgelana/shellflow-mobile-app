part of 'social_bloc.dart';

abstract class SocialEvent extends Equatable {
  const SocialEvent();

  @override
  List<Object?> get props => [];
}

// --- Feed & Tasks ---

class GetSocialFeedEvent extends SocialEvent {
  final int page;
  final int limit;
  const GetSocialFeedEvent({this.page = 1, this.limit = 20});
}

class ShareTaskToFeedEvent extends SocialEvent {
  final String taskId;
  final String? caption;
  const ShareTaskToFeedEvent({required this.taskId, this.caption});
}

class ToggleLikeTaskEvent extends SocialEvent {
  final String taskId;
  const ToggleLikeTaskEvent({required this.taskId});
}

class GetSharedTaskDetailsEvent extends SocialEvent {
  final String taskId;
  const GetSharedTaskDetailsEvent({required this.taskId});
}

// --- Comments ---

class GetTaskCommentsEvent extends SocialEvent {
  final String taskId;
  const GetTaskCommentsEvent({required this.taskId});
}

class AddCommentEvent extends SocialEvent {
  final String taskId;
  final String content;
  const AddCommentEvent({required this.taskId, required this.content});
}

class DeleteCommentEvent extends SocialEvent {
  final String commentId;
  const DeleteCommentEvent({required this.commentId});
}

// --- Friends & Connections ---

class GetFriendListEvent extends SocialEvent {
  final String? userId; // If null, gets current user's friends
  const GetFriendListEvent({this.userId});
}

class SearchUsersEvent extends SocialEvent {
  final String query;
  const SearchUsersEvent({required this.query});
}

class SendConnectionRequestEvent extends SocialEvent {
  final String targetUserId;
  const SendConnectionRequestEvent({required this.targetUserId});
}

class GetPendingRequestsEvent extends SocialEvent {
  const GetPendingRequestsEvent();
}

class HandleConnectionRequestEvent extends SocialEvent {
  final String requestId;
  final ConnectionRequestAction action; // Defined in repo/entity
  const HandleConnectionRequestEvent({required this.requestId, required this.action});
}

class RemoveFriendEvent extends SocialEvent {
  final String friendId;
  const RemoveFriendEvent({required this.friendId});
}

// --- User Profile ---

class GetSocialUserProfileEvent extends SocialEvent {
  final String userId;
  const GetSocialUserProfileEvent({required this.userId});
}