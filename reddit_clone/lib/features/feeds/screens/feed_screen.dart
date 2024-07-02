import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_new/core/common/error_text.dart';
import 'package:reddit_clone_new/core/common/loader.dart';
import 'package:reddit_clone_new/core/common/post_card.dart';
import 'package:reddit_clone_new/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_new/features/community/controller/community_controller.dart';
import 'package:reddit_clone_new/features/post/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    if (!isGuest) {
      return ref.watch(userCommunitiesProvider).when(
            data: (communites) => ref.watch(userPostsProvider(communites)).when(
                  data: (posts) {
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return PostCard(post: post);
                      },
                    );
                  },
                  error: (error, stackTrace) {
                    return ErrorText(errorText: error.toString());
                  },
                  loading: () => const Loader(),
                ),
            error: (error, stackTrace) =>
                ErrorText(errorText: error.toString()),
            loading: () => const Loader(),
          );
    } else {
      return ref.watch(userCommunitiesProvider).when(
            data: (communites) => ref.watch(guestPostsProvider).when(
                  data: (posts) {
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return PostCard(post: post);
                      },
                    );
                  },
                  error: (error, stackTrace) {
                    return ErrorText(errorText: error.toString());
                  },
                  loading: () => const Loader(),
                ),
            error: (error, stackTrace) =>
                ErrorText(errorText: error.toString()),
            loading: () => const Loader(),
          );
    }
  }
}
