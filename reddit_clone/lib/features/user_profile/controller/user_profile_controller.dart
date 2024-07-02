import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_new/core/enums/enums.dart';
import 'package:reddit_clone_new/core/providers/firebase_storage_provider.dart';
import 'package:reddit_clone_new/core/utils.dart';
import 'package:reddit_clone_new/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_new/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_clone_new/models/post_models.dart';
import 'package:reddit_clone_new/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);

  return UserProfileController(
    userProfileRepository: userProfileRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userProfileControllerProvider.notifier).getUserPosts(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editCommunity({
    required File? profileFile,
    required File? bannerFile,
    required Uint8List? profileWebFile,
    required Uint8List? bannerWebFile,
    required BuildContext context,
    required String name,
  }) async {
    state = true;

    UserModel user = _ref.read(userProvider)!;

    if (profileFile != null || profileWebFile != null) {
      final result = await _storageRepository.storeFile(
        path: 'users/profile',
        id: user.uid,
        file: profileFile,
        webFile: profileWebFile,
      );
      result.fold((l) => showSnackBar(context, l.message),
          (r) => user = user.copyWith(profilePic: r));
    }

    if (bannerFile != null || bannerWebFile != null) {
      final result = await _storageRepository.storeFile(
        path: "users/banner",
        id: user.uid,
        file: bannerFile,
        webFile: bannerWebFile,
      );

      result.fold((l) => showSnackBar(context, l.message),
          (r) => user = user.copyWith(banner: r));
    }
    user = user.copyWith(name: name);

    final result = await _userProfileRepository.editProfile(user);
    state = false;

    result.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => user);
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _userProfileRepository.getUserPosts(uid);
  }

  void updateUserKarma(UserKarma karma) async {
    UserModel user = _ref.read(userProvider)!;
    user = user.copyWith(karma: user.karma + karma.karma);

    final result = await _userProfileRepository.updateUserKarma(user);

    result.fold((l) => null,
        (r) => _ref.read(userProvider.notifier).update((state) => user));
  }
}
