import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone_new/core/failure.dart';
import 'package:reddit_clone_new/core/providers/firebase_providers.dart';
import 'package:reddit_clone_new/core/typedef.dart';

final storageRepositoryProvider = Provider(
  (ref) => StorageRepository(
    firebaseStorage: ref.watch(firebaseStorageProvider),
  ),
);

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({
    required FirebaseStorage firebaseStorage,
  }) : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File? file,
    required Uint8List? webFile,
  }) async {
    try {
      final ref =
          _firebaseStorage.ref().child(path).child(id); // users/banner/123
      UploadTask uploadTask;

      if (kIsWeb) {
        uploadTask = ref.putData(webFile!);
      } else {
        uploadTask = ref.putFile(file!);
      }

      final snapshot = await uploadTask;

      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
