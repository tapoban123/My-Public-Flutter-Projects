import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_new/core/common/error_text.dart';
import 'package:reddit_clone_new/core/common/loader.dart';
import 'package:reddit_clone_new/core/common/post_card.dart';
import 'package:reddit_clone_new/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_new/features/post/controller/post_controller.dart';
import 'package:reddit_clone_new/features/post/widgets/comment_card.dart';
import 'package:reddit_clone_new/models/post_models.dart';
import 'package:reddit_clone_new/responsive/responsive.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postID;
  const CommentsScreen({
    super.key,
    required this.postID,
  });

  @override
  ConsumerState<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
          context: context,
          text: commentController.text.trim(),
          post: post,
        );
    setState(() {
      commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
      appBar: AppBar(),
      // ! Error in this page -> getting overflow error when keypad appearing
      body: ref.watch(getPostsByIdProvider(widget.postID)).when(
            data: (data) {
              return Column(
                children: [
                  PostCard(post: data),
                  if (!isGuest)
                    Responsive(
                      child: TextField(
                        controller: commentController,
                        decoration: const InputDecoration(
                          hintText: "What are your thoughts?",
                          filled: true,
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) => addComment(data),
                      ),
                    ),
                  ref.watch(getPostCommentsProvider(widget.postID)).when(
                        data: (data) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final comment = data[index];

                                return CommentCard(comment: comment);
                              },
                            ),
                          );
                        },
                        error: (error, stackTrace) {
                          return ErrorText(
                            errorText: error.toString(),
                          );
                        },
                        loading: () => const Loader(),
                      ),
                ],
              );
            },
            error: (error, stackTrace) => ErrorText(
              errorText: error.toString(),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}
