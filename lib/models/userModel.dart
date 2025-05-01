import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String avatarPath;
  final String role;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarPath,
    required this.role,
    required this.createdAt,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      name: data['name'],
      email: data['email'],
      avatarPath: data['avatarPath'] ?? '',
      role: data['role'] ?? 'user',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}