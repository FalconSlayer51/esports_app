import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddCommentScreen extends StatefulWidget {
  final String postId; // Pass postId to identify the post to add comment to

  const AddCommentScreen({Key? key, required this.postId}) : super(key: key);

  static Route getRoute(String postId) {
    return MaterialPageRoute<void>(
      builder: (_) => AddCommentScreen(postId: postId),
    );
  }

  @override
  _AddCommentScreenState createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _addComment() async {
    if (_commentController.text.isEmpty) return;

    final commentText = _commentController.text;
    final userId = user?.uid;
    final userName =
        user?.displayName ?? 'Anonymous'; // Placeholder if username not set

    // Reference to the post's comments subcollection
    final commentsRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments');

    // Add a new comment document with relevant fields
    await commentsRef.add({
      'content': commentText,
      'userId': userId,
      'username': userName,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .update({
      'commentsCount': FieldValue.increment(1),
    });

    // Clear the input after submission
    _commentController.clear();

    // Show confirmation (or close the screen, if desired)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comment added')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Comment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Comment input field
            TextField(
              controller: _commentController,
              maxLines: null, // Allows multi-line comments
              decoration: InputDecoration(
                labelText: 'Write a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Submit button
            ElevatedButton(
              onPressed: _addComment,
              style: ElevatedButton.styleFrom(
                minimumSize:
                    const Size(double.infinity, 50), // Full-width button
              ),
              child: const Text('Add Comment'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
