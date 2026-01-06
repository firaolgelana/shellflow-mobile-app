class SocialActivity {
  final String id;
  final String description; // e.g., "John liked your task"
  final DateTime timestamp;
  final String type; // 'like', 'comment', 'request'

  SocialActivity({
    required this.id,
    required this.description,
    required this.timestamp,
    required this.type,
  });
}