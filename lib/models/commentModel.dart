


class Comment {
  final String id;
  final String userId;
  final String landmarkId;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.userId,
    required this.landmarkId,
    required this.text,
    required this.timestamp,
  });
}