class SocialUser {
  final String id;
  final String username;
  final String photoUrl;
  final String? bio;
  final bool isFriend;
  final bool isFollowing;
  final ConnectionStatus connectionStatus;
  final int mutualFriendsCount;
  final bool isBlocked;

  SocialUser({
    required this.id,
    required this.username,
    required this.photoUrl,
    this.bio,
    this.isFriend = false,
    this.isFollowing = false,
    this.connectionStatus = ConnectionStatus.none,
    this.mutualFriendsCount = 0,
    this.isBlocked = false,
  });
}

enum ConnectionStatus { none, pendingSent, pendingReceived, accepted, blocked }
