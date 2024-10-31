import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostDetailsScreen extends StatelessWidget {
  final String postId;
  final String profileImageUrl;
  final String username;

  static Route getRoute(
      String postId, String profileImageUrl, String username) {
    return MaterialPageRoute(
      builder: (context) => PostDetailsScreen(
        postId: postId,
        profileImageUrl: profileImageUrl,
        username: username,
      ),
    );
  }

  const PostDetailsScreen({
    Key? key,
    required this.postId,
    required this.profileImageUrl,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Post Details', style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .snapshots(),
        builder: (context, postSnapshot) {
          if (postSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!postSnapshot.hasData || !postSnapshot.data!.exists) {
            return Center(
                child: Text('Post not found.',
                    style: Theme.of(context).textTheme.bodyLarge));
          }

          final postData = postSnapshot.data!;
          final content = postData['content'] ?? '';
          final imageUrl = postData['imageUrl'];
          final likesCount = postData['likesCount'] ?? 0;
          final commentsCount = postData['commentsCount'] ?? 0;

          return SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(profileImageUrl),
                              radius: 24,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  username,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatTimestamp(
                                      postData['timestamp'].toDate()),
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          content,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontSize: 18),
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
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.favorite,
                                    color: Colors.red, size: 22),
                                const SizedBox(width: 4),
                                Text(
                                  '$likesCount Likes',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.comment,
                                    color: Colors.grey.shade600, size: 22),
                                const SizedBox(width: 4),
                                Text(
                                  '$commentsCount Comments',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Comments",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId)
                      .collection('comments')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, commentsSnapshot) {
                    if (commentsSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!commentsSnapshot.hasData ||
                        commentsSnapshot.data!.docs.isEmpty) {
                      return Center(
                          child: Text('No comments yet.',
                              style: Theme.of(context).textTheme.bodyMedium));
                    }

                    final comments = commentsSnapshot.data!.docs;

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        final content = comment['content'] ?? '';
                        final commentUsername =
                            comment['username'] ?? 'Anonymous';
                        final timestamp =
                            (comment['timestamp'] as Timestamp?)?.toDate();

                        return FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(comment['userId'])
                                .get(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) return Container();

                              final userData = snapshot.data!;
                              final userName =
                                  userData['displayName'] ?? 'User';
                              final userProfileImage = userData['photoURL'];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          userProfileImage.isNotEmpty
                                              ? NetworkImage(userProfileImage)
                                              : null,
                                      backgroundColor: Colors.grey.shade300,
                                      child: userProfileImage.isEmpty
                                          ? Text(
                                              commentUsername[0].toUpperCase(),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                commentUsername,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                timestamp != null
                                                    ? _formatTimestamp(
                                                        timestamp)
                                                    : '',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            content,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return DateFormat.yMMMd().format(timestamp);
    } else if (difference.inDays >= 1) {
      return "${difference.inDays} days ago";
    } else if (difference.inHours >= 1) {
      return "${difference.inHours} hours ago";
    } else if (difference.inMinutes >= 1) {
      return "${difference.inMinutes} minutes ago";
    } else {
      return "Just now";
    }
  }
}
