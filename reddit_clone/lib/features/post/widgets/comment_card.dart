import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_new/models/comment.dart';
import 'package:reddit_clone_new/responsive/responsive.dart';

class CommentCard extends ConsumerWidget {
  final Comment comment;
  const CommentCard({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ! No delete option, re-check comment display style
    return Responsive(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(comment.profilePic),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left:16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "u/${comment.userName}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          comment.text,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.reply),
            ),
            const Text("Reply"),
          ],
        ),
      ),
    );
  }
}
