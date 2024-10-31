import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  static Route getRoute() {
    return MaterialPageRoute<void>(
      builder: (_) => AddPostScreen(),
    );
  }

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _postController = TextEditingController();
  final int _maxCharacters = 280;
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imagesRef = storageRef
          .child("post_images/${DateTime.now().toIso8601String()}.jpg");

      await imagesRef.putFile(imageFile);
      return await imagesRef.getDownloadURL();
    } catch (e) {
      print("Image upload failed: $e");
      return null;
    }
  }

  Future<void> addComment(String postId, String commentText) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null && commentText.isNotEmpty) {
      // Add the comment to the comments subcollection
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add({
        'userId': userId,
        'commentText': commentText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Increment the commentsCount in the post document
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'commentsCount': FieldValue.increment(1),
      });
    }
  }

  Future<void> _submitPost() async {
    if (_postController.text.isEmpty ||
        _postController.text.length > _maxCharacters) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    String? imageUrl;
    if (_selectedImage != null) {
      imageUrl = await _uploadImage(File(_selectedImage!.path));
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;
    final postContent = _postController.text;

    if (userId != null) {
      // Add the new post to Firestore
      DocumentReference postRef =
          await FirebaseFirestore.instance.collection('posts').add({
        'uid': userId,
        'content': postContent,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'likesCount': 0,
        'likedBy': [],
        'commentsCount': 0,
      });

      // Clear the post field and image after submitting
      _postController.clear();
      setState(() {
        _selectedImage = null;
      });
    }

    setState(() {
      isLoading = false;
    });

    // Navigate back or show a confirmation message
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
        actions: [
          TextButton(
            onPressed: _postController.text.isEmpty ||
                    _postController.text.length > _maxCharacters
                ? null
                : _submitPost,
            child: Text(
              'Post',
              style: TextStyle(
                color: _postController.text.isEmpty ||
                        _postController.text.length > _maxCharacters
                    ? Colors.grey
                    : Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextField for post content
            TextField(
              controller: _postController,
              maxLength: _maxCharacters,
              maxLines: null,
              onChanged: (text) => setState(() {}),
              decoration: const InputDecoration(
                hintText: "What's happening?",
                border: InputBorder.none,
              ),
            ),

            // Character Counter
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${_postController.text.length} / $_maxCharacters",
                  style: TextStyle(
                    color: _postController.text.length > _maxCharacters
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Image Preview
            if (_selectedImage != null)
              Stack(
                children: [
                  Image.file(
                    File(_selectedImage!.path),
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedImage = null;
                        });
                      },
                      child: const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.black54,
                        child: Icon(Icons.close, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),

            // Add Image Button
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image, color: Colors.blue),
                  onPressed: _pickImage,
                ),
                const Text(
                  'Add Photo',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
