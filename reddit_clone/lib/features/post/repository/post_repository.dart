import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone_new/constants/firebase_constants.dart';
import 'package:reddit_clone_new/core/failure.dart';
import 'package:reddit_clone_new/core/providers/firebase_providers.dart';
import 'package:reddit_clone_new/core/typedef.dart';
import 'package:reddit_clone_new/models/community_model.dart';
import 'package:reddit_clone_new/models/post_models.dart';

import '../../../models/comment.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.watch(firestoreProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.userCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    return _posts
        .where("communityName",
            whereIn: communities.map((e) => e.name).toList())
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void upVote(Post post, String userID) async {
    if (post.downVotes.contains(userID)) {
      _posts.doc(post.id).update({
        "downVotes": FieldValue.arrayRemove([userID]),
      });
    }

    if (post.upVotes.contains(userID)) {
      _posts.doc(post.id).update({
        "upVotes": FieldValue.arrayRemove([userID]),
      });
    } else {
      _posts.doc(post.id).update({
        "upVotes": FieldValue.arrayUnion([userID]),
      });
    }
  }

  void downVote(Post post, String userID) async {
    if (post.upVotes.contains(userID)) {
      _posts.doc(post.id).update({
        "upVotes": FieldValue.arrayRemove([userID]),
      });
    }

    if (post.downVotes.contains(userID)) {
      _posts.doc(post.id).update({
        "downVotes": FieldValue.arrayRemove([userID]),
      });
    } else {
      _posts.doc(post.id).update({
        "downVotes": FieldValue.arrayUnion([userID]),
      });
    }
  }

  Stream<Post> getPostByID(String postID) {
    return _posts
        .doc(postID)
        .snapshots()
        .map((event) => Post.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid addComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());

      return right(
        _posts.doc(comment.postID).update(
          {
            "commentCount": FieldValue.increment(1),
          },
        ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Comment>> getCommentsOfPost(String postID) {
    return _comments
        .where('postID', isEqualTo: postID)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => Comment.fromMap(
                e.data() as Map<String, dynamic>,
              ),
            )
            .toList());
  }

  FutureVoid awardPost(Post post, String award, String senderId) async {
    try {
      _posts.doc(post.id).update({
        'awards': FieldValue.arrayUnion([award])
      });
      _users.doc(senderId).update({
        "award": FieldValue.arrayRemove([award])
      });

      return right(_users.doc(post.uid).update({
        "award": FieldValue.arrayUnion([award])
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchGuestPosts() {
    return _posts
        .orderBy("createdAt", descending: true)
        .limit(10)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
              .toList(),
        );
  }
}
