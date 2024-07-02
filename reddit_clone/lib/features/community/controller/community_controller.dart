import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone_new/constants/constants.dart';
import 'package:reddit_clone_new/core/failure.dart';
import 'package:reddit_clone_new/core/providers/firebase_storage_provider.dart';
import 'package:reddit_clone_new/core/utils.dart';
import 'package:reddit_clone_new/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_new/features/community/repository/community_repository.dart';
import 'package:reddit_clone_new/models/community_model.dart';
import 'package:reddit_clone_new/models/post_models.dart';
import 'package:routemaster/routemaster.dart';

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});
final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);

  return CommunityController(
    communityRepository: communityRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});

final getCommunityPostsProvider = StreamProvider.family((ref, String name) {
  return ref.read(communityControllerProvider.notifier).getCommunityPosts(name);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;

    final uid = _ref.read(userProvider)?.uid ?? "";
    Community community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );
    final result = await _communityRepository.createCommunity(community);
    state = false;

    result.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, "Community created successfully!");
      Routemaster.of(context).pop();
    });
  }

  void joinCommunity(Community community, BuildContext context) async {
    final user = _ref.read(userProvider)!;

    Either<Failure, void> result;

    if (community.members.contains(user.uid)) {
      result =
          await _communityRepository.leaveCommunity(community.name, user.uid);
    } else {
      result =
          await _communityRepository.joinCommunity(community.name, user.uid);
    }

    result.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        if (community.members.contains(user.uid)) {
          showSnackBar(context, "Community left successfully.");
        } else {
          showSnackBar(context, "Community joined successfully.");
        }
      },
    );
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;

    return _communityRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity({
    required File? profileFile,
    required File? bannerFile,
    required Uint8List? profileWebFile,
    required Uint8List? bannerWebFile,
    required BuildContext context,
    required Community community,
  }) async {
    state = true;
    // communities/profile/memes
    if (profileFile != null || profileWebFile != null) {
      final result = await _storageRepository.storeFile(
          path: 'communities/profile',
          id: community.name,
          file: profileFile,
          webFile: profileWebFile);
      result.fold((l) => showSnackBar(context, l.message),
          (r) => community = community.copyWith(avatar: r));
    }

    // communities/banner/memes
    if (bannerFile != null || bannerWebFile != null) {
      final result = await _storageRepository.storeFile(
          path: "communities/banner",
          id: community.name,
          file: bannerFile,
          webFile: bannerWebFile);

      result.fold((l) => showSnackBar(context, l.message),
          (r) => community = community.copyWith(banner: r));
    }

    final result = await _communityRepository.editCommunity(community);
    state = false;

    result.fold((l) => showSnackBar(context, l.message),
        (r) => Routemaster.of(context).pop());
  }

  void addMods(
      String communityName, List<String> uids, BuildContext context) async {
    final result = await _communityRepository.addMods(communityName, uids);

    result.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  Stream<List<Post>> getCommunityPosts(String name) {
    return _communityRepository.getCommunityPosts(name);
  }
}
