import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esports_app/community/add_post_screen.dart';
import 'package:esports_app/community/post_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'add_comment_screen.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  // Toggle the like status for a post
  Future<void> toggleLike(String postId, bool isLiked) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(postRef);

      if (!snapshot.exists) return;

      final likesCount = snapshot['likesCount'] ?? 0;
      final likedBy = List<String>.from(snapshot['likedBy'] ?? []);

      if (isLiked) {
        // If the post is already liked, remove the like
        transaction.update(postRef, {
          'likesCount': likesCount - 1,
          'likedBy': FieldValue.arrayRemove([userId]),
        });
      } else {
        // If not liked yet, add a like
        transaction.update(postRef, {
          'likesCount': likesCount + 1,
          'likedBy': FieldValue.arrayUnion([userId]),
        });
      }
    });
  }

  String formatTimestamp(Timestamp timestamp) {
    final postDate = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(postDate);

    if (difference.inDays > 1) {
      return timeago.format(postDate);
    } else {
      return timeago.format(postDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId1 = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No posts yet.'));
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final postId = post.id;
              final content = post['content'] ?? '';
              final imageUrl = post['imageUrl'];
              final likesCount = post['likesCount'] ?? 0;
              final likedBy = List<String>.from(post['likedBy'] ?? []);
              final isLiked = likedBy.contains(userId1);
              final commentsCount = post['commentsCount'] ?? 0;
              final timestamp =
                  post['timestamp'] as Timestamp? ?? Timestamp.now();
              final postTime = formatTimestamp(timestamp);
              final userId = post['uid'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) return Container();

                  final userData = userSnapshot.data!;
                  final userName = userData['displayName'] ?? 'User';
                  final userProfileImage = userData['photoURL'];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PostDetailsScreen.getRoute(
                            postId,
                            userProfileImage,
                            userName,
                          ));
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // User Info Row
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: userProfileImage != null
                                      ? NetworkImage(userProfileImage)
                                      : const AssetImage('assets/images.png')
                                          as ImageProvider,
                                  radius: 20,
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      postTime,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Post content
                            Text(
                              content,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            if (imageUrl != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            const SizedBox(height: 8),
                            // Like and comment section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Like button
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.favorite,
                                        color:
                                            isLiked ? Colors.red : Colors.grey,
                                      ),
                                      onPressed: () =>
                                          toggleLike(postId, isLiked),
                                    ),
                                    Text('$likesCount'),
                                  ],
                                ),
                                // Comments count
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      AddCommentScreen.getRoute(postId),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(Icons.comment,
                                          color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text('$commentsCount'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            AddPostScreen.getRoute(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
