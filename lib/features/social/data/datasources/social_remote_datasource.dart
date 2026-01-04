import 'package:flutter/cupertino.dart';
import 'package:shell_flow_mobile_app/core/errors/failure.dart';
import 'package:shell_flow_mobile_app/features/profile/data/models/user_profile_model.dart';
import 'package:shell_flow_mobile_app/features/social/data/models/connection_request_model.dart';
import 'package:shell_flow_mobile_app/features/social/data/models/social_comment_model.dart';
import 'package:shell_flow_mobile_app/features/social/data/models/social_task_model.dart';
import 'package:shell_flow_mobile_app/features/social/data/models/social_user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shell_flow_mobile_app/features/profile/domain/entities/user_profile.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/connection_request.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_comment.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_task.dart';
import 'package:shell_flow_mobile_app/features/social/domain/entities/social_user.dart';
import 'package:shell_flow_mobile_app/features/social/domain/repositories/social_repository.dart';

// Abstract class (from your prompt)
abstract class SocialRemoteDatasource {
  Future<SocialComment> addComment({
    required String taskId,
    required String content,
  });
  Future<void> deleteComment({required String commentId});
  Future<List<SocialUser>> getFriendList({String? userId});
  Future<List<ConnectionRequest>> getPendingRequests();
  Future<List<SocialTask>> getSocialFeed({int page = 1, int limit = 20});
  Future<UserProfile> getSocialUserProfile({required String userId});
  Future<List<SocialComment>> getTaskComments({required String taskId});
  Future<void> handleConnectionRequest({
    required String requestId,
    required ConnectionRequestAction action,
  });
  Future<void> removeFriend({required String friendId});
  Future<List<SocialUser>> searchUsers({required String query});
  Future<ConnectionRequest> sendConnectionRequest({
    required String targetUserId,
  });
  Future<SocialTask> shareTaskToFeed({required String taskId, String? caption});
  Future<void> toggleLikeTask({required String taskId});
  Future<SocialTask> getSharedTaskDetails({required String taskId});
}

class SocialRemoteDatasourceImpl implements SocialRemoteDatasource {
  final SupabaseClient supabase;

  SocialRemoteDatasourceImpl({required this.supabase});

  String get _currentUserId => supabase.auth.currentUser!.id;

  @override
  Future<SocialComment> addComment({
    required String taskId,
    required String content,
  }) async {
    try {
      final response = await supabase
          .from('social_comments')
          .insert({
            'task_id': taskId,
            'user_id': _currentUserId,
            'content': content,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select('*, profiles(*)') // Join with profile to get author details
          .single();

      return SocialCommentModel.fromJson(response);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> deleteComment({required String commentId}) async {
    try {
      await supabase
          .from('social_comments')
          .delete()
          .eq('id', commentId)
          .eq('user_id', _currentUserId); // Security check
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<SocialUser>> getFriendList({String? userId}) async {
    final targetId = userId ?? _currentUserId;
    try {
      // Logic: Find connections where status is accepted and targetId is involved
      final response = await supabase
          .from('friendships')
          .select('sender:sender_id(*), receiver:receiver_id(*)')
          .or('sender_id.eq.$targetId,receiver_id.eq.$targetId')
          .eq('status', 'accepted');

      final List<SocialUser> friends = [];

      for (var record in response) {
        // If I am the sender, the friend is the receiver, and vice versa
        final isSender = record['sender']['id'] == targetId;
        final friendData = isSender ? record['receiver'] : record['sender'];
        friends.add(SocialUserModel.fromJson(friendData));
      }

      return friends;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<ConnectionRequest>> getPendingRequests() async {
    try {
      // Get requests where I am the receiver and status is pending
      final response = await supabase
          .from('friendships')
          .select('*, sender:sender_id(*)') // Fetch sender details
          .eq('receiver_id', _currentUserId)
          .eq('status', 'pending');

      return (response as List)
          .map((e) => ConnectionRequestModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<SocialTask> getSharedTaskDetails({required String taskId}) async {
    try {
      final response = await supabase
          .from('tasks')
          .select('*, profiles(*)') // Get author details
          .eq('id', taskId)
          .single();

      return SocialTaskModel.fromJson(response);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<SocialTask>> getSocialFeed({int page = 1, int limit = 20}) async {
    try {
      // Ideally, use a Postgres RPC (function) for complex feed logic (friends' posts only).
      // For this example, we fetch 'public' or 'shared' tasks globally or filter client side.
      final start = (page - 1) * limit;
      final end = start + limit - 1;

      final response = await supabase
          .from('tasks')
          .select(
            '*, profiles(*), likes(count)',
          ) // Join profile and count likes
          .eq('is_shared', true)
          .order('shared_at', ascending: false)
          .range(start, end);

      return (response as List)
          .map((e) => SocialTaskModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<UserProfile> getSocialUserProfile({required String userId}) async {
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<SocialComment>> getTaskComments({required String taskId}) async {
    try {
      final response = await supabase
          .from('social_comments')
          .select('*, profiles(*)') // Join with author profile
          .eq('task_id', taskId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((e) => SocialCommentModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> handleConnectionRequest({
    required String requestId,
    required ConnectionRequestAction action,
  }) async {
    try {
      if (action == ConnectionRequestAction.accept) {
        await supabase
            .from('friendships')
            .update({'status': 'accepted'})
            .eq('id', requestId);
      } else {
        // Decline usually means deleting the request or setting status to declined
        await supabase.from('friendships').delete().eq('id', requestId);
      }
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> removeFriend({required String friendId}) async {
    try {
      // Delete the row where (me, friend) OR (friend, me) exists
      await supabase
          .from('friendships')
          .delete()
          .or(
            'and(sender_id.eq.$_currentUserId,receiver_id.eq.$friendId),and(sender_id.eq.$friendId,receiver_id.eq.$_currentUserId)',
          );
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<List<SocialUser>> searchUsers({required String query}) async {
    try {
      final response = await supabase
          .from('profiles')
          .select('*')
          // .ilike('username', '%$query%') 
          .limit(10);

      // --- DEBUGGING START ---
      // debugPrint('----------------- API RESPONSE -----------------');
      
      // // 1. Check if it's empty
      // if ((response as List).isEmpty) {
      //   debugPrint('Response is EMPTY list []');
      // } else {
      //   // 2. Pretty print the JSON data
      //   String prettyJson = const JsonEncoder.withIndent('  ').convert(response);
      //   debugPrint(prettyJson);
      // }
      // debugPrint('------------------------------------------------');
      // // --- DEBUGGING END ---

      return (response as List)
          .map((e) => SocialUserModel.fromJson(e)) // Ensure you use SocialUserModel here
          .toList();
    } catch (e) {
      debugPrint('ERROR FETCHING USERS: $e'); // Print the error too
      throw ServerFailure(message: e.toString());
    }
  }
  @override
  Future<ConnectionRequest> sendConnectionRequest({
    required String targetUserId,
  }) async {
    try {
      final response = await supabase
          .from('friendships')
          .insert({
            'sender_id': _currentUserId,
            'receiver_id': targetUserId,
            'status': 'pending',
          })
          .select('*, sender:sender_id(*)') // return the created object
          .single();

      return ConnectionRequestModel.fromJson(response);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<SocialTask> shareTaskToFeed({
    required String taskId,
    String? caption,
  }) async {
    try {
      final response = await supabase
          .from('tasks')
          .update({
            'is_shared': true,
            'shared_at': DateTime.now().toIso8601String(),
            'caption': caption,
          })
          .eq('id', taskId)
          .select('*, profiles(*)')
          .single();

      return SocialTaskModel.fromJson(response);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<void> toggleLikeTask({required String taskId}) async {
    try {
      // 1. Check if like exists
      final existingLike = await supabase
          .from('likes')
          .select()
          .eq('user_id', _currentUserId)
          .eq('task_id', taskId)
          .maybeSingle();

      if (existingLike != null) {
        // Unlike
        await supabase.from('likes').delete().eq('id', existingLike['id']);
      } else {
        // Like
        await supabase.from('likes').insert({
          'user_id': _currentUserId,
          'task_id': taskId,
        });
      }
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
