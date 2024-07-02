import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_new/core/common/error_text.dart';
import 'package:reddit_clone_new/core/common/loader.dart';
import 'package:reddit_clone_new/core/common/post_card.dart';
import 'package:reddit_clone_new/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_new/features/community/controller/community_controller.dart';
import 'package:reddit_clone_new/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String communityName;
  const CommunityScreen({
    super.key,
    required this.communityName,
  });

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push("/r/$communityName/mod-tools/$communityName");
  }

  void joinCommunity(WidgetRef ref, Community community, BuildContext context) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(communityName)).when(
            data: (community) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    expandedHeight: 150,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            community.banner,
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                            radius: 35,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "r/${community.name}",
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (!isGuest)
                              community.mods.contains(user.uid)
                                  ? OutlinedButton(
                                      onPressed: () =>
                                          navigateToModTools(context),
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                      ),
                                      child: const Text(
                                        "Mod Tools",
                                        style: TextStyle(),
                                      ),
                                    )
                                  : OutlinedButton(
                                      onPressed: () => joinCommunity(
                                          ref, community, context),
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                      ),
                                      child: Text(
                                        community.members.contains(user.uid)
                                            ? "Joined"
                                            : "Join",
                                        style: const TextStyle(),
                                      ),
                                    ),
                            ]),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(community.mods.length > 1
                              ? "${community.mods.length} members"
                              : "${community.mods.length} member"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                      ]),
                    ),
                  )
                ];
              },
              body: ref.watch(getCommunityPostsProvider(communityName)).when(
                    data: (communityPosts) {
                      return ListView.builder(
                        itemCount: communityPosts.length,
                        itemBuilder: (context, index) {
                          final post = communityPosts[index];
                          return PostCard(post: post);
                        },
                      );
                    },
                    error: (error, stackTrace) =>
                        ErrorText(errorText: error.toString()),
                    loading: () => const Loader(),
                  ),
            ),
            error: (error, stackTrace) {
              return ErrorText(errorText: error.toString());
            },
            loading: () => const Loader(),
          ),
      //
    );
  }
}
