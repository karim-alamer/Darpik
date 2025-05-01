import 'package:darpik/controllers/landmark_controller.dart';
import 'package:darpik/models/commentModel.dart';
import 'package:flutter/material.dart';

class CommentsSection extends StatelessWidget {
  final List<Comment> comments;
  final LandmarkService controller;

  const CommentsSection({
    super.key,
    required this.comments,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Comments',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ...comments.map((comment) => _buildCommentItem(comment)),
      ],
    );
  }

  Widget _buildCommentItem(Comment comment) {
    final user =
        controller.users.firstWhere((user) => user.id == comment.userId);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(user.avatarPath),
      ),
      title: Text(user.name),
      subtitle: Text(comment.text),
    );
  }
}

//   Widget _buildCommentsSection(List<Comment> comments) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 20),
//         const Text('Comments',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         ...comments.map((comment) => _buildCommentItem(comment)),
//       ],
//     );
//   }

//   Widget _buildCommentItem(Comment comment) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundImage: AssetImage(controller.users
//             .firstWhere((user) => user.id == comment.userId)
//             .avatarPath),
//       ),
//       title: Text(controller.users
//           .firstWhere((user) => user.id == comment.userId)
//           .name),
//       subtitle: Text(comment.text),
//     );
//   }