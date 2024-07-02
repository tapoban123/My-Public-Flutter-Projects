import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_new/constants/constants.dart';
import 'package:reddit_clone_new/core/common/error_text.dart';
import 'package:reddit_clone_new/core/common/loader.dart';
import 'package:reddit_clone_new/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_new/features/community/controller/community_controller.dart';
import 'package:reddit_clone_new/features/post/controller/post_controller.dart';
import 'package:reddit_clone_new/models/post_models.dart';
import 'package:reddit_clone_new/responsive/responsive.dart';
import 'package:reddit_clone_new/theme/colors.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  void deletePost(WidgetRef ref, BuildContext context) {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void upVotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upVote(post);
  }

  void downVotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downVote(post);
  }

  void awardPost(WidgetRef ref, String award, BuildContext context) async {
    ref
        .read(postControllerProvider.notifier)
        .awardPost(post: post, award: award, context: context);
  }

  void navigateToUserProfile(BuildContext context) {
    Routemaster.of(context).push('/u/${post.uid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push("/r/${post.communityName}");
  }

  void navigateToCommentsPage(BuildContext context) {
    Routemaster.of(context).push("/posts/${post.id}/comments");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isTypeImage = post.type == "image";
    bool isTypeText = post.type == "text";
    bool isTypeLink = post.type == "link";

    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    final isGuest = !user.isAuthenticated;

    return Responsive(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: currentTheme.drawerTheme.backgroundColor,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(kIsWeb)
                Column(
                  children: [
                    IconButton(
                      onPressed: isGuest ? () {} : () => upVotePost(ref),
                      icon: Icon(
                        Icons.arrow_upward,
                        size: 30,
                        color: post.upVotes.contains(user.uid)
                            ? Pallete.redColor
                            : null,
                      ),
                    ),
                    Text(
                      "${post.upVotes.length - post.downVotes.length == 0 ? "Vote" : post.upVotes.length - post.downVotes.length}",
                      style: const TextStyle(fontSize: 17),
                    ),
                    IconButton(
                      onPressed: isGuest ? () {} : () => downVotePost(ref),
                      icon: Icon(
                        Icons.arrow_downward,
                        size: 30,
                        color: post.downVotes.contains(user.uid)
                            ? Pallete.blueColor
                            : null,
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 16,
                        ).copyWith(right: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => navigateToCommunity(context),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            post.communityProfilePic),
                                        radius: 16,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () =>
                                                navigateToCommunity(context),
                                            child: Text(
                                              "r/${post.communityName}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                navigateToUserProfile(context),
                                            child: Text(
                                              "u/${post.userName}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (post.uid == user.uid)
                                  IconButton(
                                    onPressed: () => deletePost(ref, context),
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  )
                              ],
                            ),
                            if (post.awards.isNotEmpty) ...[
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 25,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: post.awards.length,
                                  itemBuilder: (context, index) {
                                    final award = post.awards[index];
                                    return Image.asset(
                                      Constants.awards[award]!,
                                      height: 23,
                                    );
                                  },
                                ),
                              )
                            ],
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                post.title,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isTypeImage)
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                width: double.infinity,
                                child: Image.network(
                                  post.link!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if (isTypeLink)
                              Container(
                                height: 150,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                width: double.infinity,
                                child: AnyLinkPreview(
                                    displayDirection:
                                        UIDirection.uiDirectionHorizontal,
                                    link: post.link!),
                              ),
                            if (isTypeText)
                              Container(
                                alignment: Alignment.bottomLeft,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  post.description!,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (!kIsWeb)
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: isGuest
                                            ? () {}
                                            : () => upVotePost(ref),
                                        icon: Icon(
                                          Icons.arrow_upward,
                                          size: 30,
                                          color: post.upVotes.contains(user.uid)
                                              ? Pallete.redColor
                                              : null,
                                        ),
                                      ),
                                      Text(
                                        "${post.upVotes.length - post.downVotes.length == 0 ? "Vote" : post.upVotes.length - post.downVotes.length}",
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                      IconButton(
                                        onPressed: isGuest
                                            ? () {}
                                            : () => downVotePost(ref),
                                        icon: Icon(
                                          Icons.arrow_downward,
                                          size: 30,
                                          color:
                                              post.downVotes.contains(user.uid)
                                                  ? Pallete.blueColor
                                                  : null,
                                        ),
                                      )
                                    ],
                                  ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () =>
                                                navigateToCommentsPage(context),
                                            icon: const Icon(Icons.comment)),
                                        Text(
                                          "${post.commentCount == 0 ? "Comment" : post.commentCount}",
                                          style: const TextStyle(fontSize: 17),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                ref
                                    .watch(getCommunityByNameProvider(
                                        post.communityName))
                                    .when(
                                      data: (data) {
                                        if (data.mods.contains(user.uid)) {
                                          return IconButton(
                                            onPressed: () =>
                                                deletePost(ref, context),
                                            icon: const Icon(
                                                Icons.admin_panel_settings),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                      error: (error, stackTrace) => ErrorText(
                                          errorText: error.toString()),
                                      loading: () => const Loader(),
                                    ),
                                IconButton(
                                  onPressed: isGuest
                                      ? () {}
                                      : () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: GridView.builder(
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 4),
                                                  itemCount: user.awards.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final award =
                                                        user.awards[index];
                                                    return GestureDetector(
                                                      onTap: () => awardPost(
                                                          ref, award, context),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Image.asset(
                                                            Constants.awards[
                                                                award]!),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                  icon:
                                      const Icon(Icons.card_giftcard_outlined),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
