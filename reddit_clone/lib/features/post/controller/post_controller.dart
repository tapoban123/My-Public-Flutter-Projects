import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_new/core/enums/enums.dart';
import 'package:reddit_clone_new/core/providers/firebase_storage_provider.dart';
import 'package:reddit_clone_new/core/utils.dart';
import 'package:reddit_clone_new/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_new/features/post/repository/post_repository.dart';
import 'package:reddit_clone_new/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit_clone_new/models/comment.dart';
import 'package:reddit_clone_new/models/community_model.dart';
import 'package:reddit_clone_new/models/post_models.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);

  return PostController(
    postRepository: postRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final userPostsProvider =
    StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postControllerProvider.notifier);

  return postController.fetchUserPosts(communities);
});
final guestPostsProvider = StreamProvider((ref) {
  final postController = ref.watch(postControllerProvider.notifier);

  return postController.fetchGuestPosts();
});

final getPostsByIdProvider = StreamProvider.family((ref, String postID) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostByID(postID);
});
final getPostCommentsProvider = StreamProvider.family((ref, String postID) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchPostComments(postID);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  PostController({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareTextPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String description,
  }) async {
    state = true;

    String postID = Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postID,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upVotes: [],
      downVotes: [],
      commentCount: 0,
      userName: user.name,
      uid: user.uid,
      type: "text",
      createdAt: DateTime.now(),
      awards: [],
      description: description,
    );

    final res = await _postRepository.addPost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.textPost);
    state = false;

    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, "Posted Successfully!");
      Routemaster.of(context).pop();
    });
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String link,
  }) async {
    state = true;

    String postID = Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postID,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upVotes: [],
      downVotes: [],
      commentCount: 0,
      userName: user.name,
      uid: user.uid,
      type: "link",
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );

    final res = await _postRepository.addPost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.linkPost);
    state = false;

    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, "Posted Successfully!");
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required File? imageFile,
    required Uint8List? webFile,
  }) async {
    state = true;

    String postID = Uuid().v1();
    final user = _ref.read(userProvider)!;
    final imageResult = await _storageRepository.storeFile(
      path: "posts/${selectedCommunity.name}",
      id: postID,
      file: imageFile,
      webFile: webFile,
    );

    imageResult.fold((l) => showSnackBar(context, l.message), (r) async {
      final Post post = Post(
        id: postID,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upVotes: [],
        downVotes: [],
        commentCount: 0,
        userName: user.name,
        uid: user.uid,
        type: "image",
        createdAt: DateTime.now(),
        awards: [],
        link: r,
      );

      final res = await _postRepository.addPost(post);
      _ref
          .read(userProfileControllerProvider.notifier)
          .updateUserKarma(UserKarma.imagePost);
      state = false;

      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, "Posted Successfully!");
        Routemaster.of(context).pop();
      });
    });
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    }
    return Stream.value([]);
  }

  Stream<List<Post>> fetchGuestPosts() {
    return _postRepository.fetchGuestPosts();
  }

  void deletePost(Post post, BuildContext context) async {
    final result = await _postRepository.deletePost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.deletePost);

    return result.fold((l) => null,
        (r) => showSnackBar(context, "Post Deleted Successfully!"));
  }

  void upVote(Post post) async {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.upVote(post, uid);
  }

  void downVote(Post post) async {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.downVote(post, uid);
  }

  Stream<Post> getPostByID(String postID) {
    return _postRepository.getPostByID(postID);
  }

  void addComment({
    required BuildContext context,
    required String text,
    required Post post,
  }) async {
    final user = _ref.read(userProvider)!;
    String commentID = Uuid().v1();

    Comment comment = Comment(
      id: commentID,
      text: text,
      createdAt: DateTime.now(),
      postID: post.id,
      userName: user.name,
      profilePic: user.profilePic,
    );
    final result = await _postRepository.addComment(comment);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.comment);

    result.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  void awardPost({
    required Post post,
    required String award,
    required BuildContext context,
  }) async {
    final user = _ref.read(userProvider)!;

    final result = await _postRepository.awardPost(post, award, user.uid);

    result.fold((l) => showSnackBar(context, l.message), (r) {
      _ref
          .read(userProfileControllerProvider.notifier)
          .updateUserKarma(UserKarma.awardPost);
      _ref.read(userProvider.notifier).update((state) {
        state?.awards.remove(award);
        return state;
      });
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Comment>> fetchPostComments(String postID) {
    return _postRepository.getCommentsOfPost(postID);
  }
}
