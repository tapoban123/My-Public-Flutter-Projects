import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone_new/constants/constants.dart';
import 'package:reddit_clone_new/constants/firebase_constants.dart';
import 'package:reddit_clone_new/core/failure.dart';
import 'package:reddit_clone_new/core/providers/firebase_providers.dart';
import 'package:reddit_clone_new/core/typedef.dart';
import 'package:reddit_clone_new/models/user_model.dart';

// Wrapping the AuthRespository class instance inside a provider so we don't have to create an instance of the class
// again and again
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firebaseAuth:
        ref.read(authProvider), // use ref.read outside the build function
    firebaseFirestore: ref.read(firestoreProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firebaseFirestore,
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth =
            firebaseAuth, // Assigning private variables to constructor parameters
        _googleSignIn = googleSignIn,
        _firebaseFirestore = firebaseFirestore;
  CollectionReference get _users =>
      _firebaseFirestore.collection(FirebaseConstants.userCollection);

  Stream<User?> get authStateChanges =>
      _firebaseAuth.authStateChanges(); // getting user authStateChanges

  // method to sign in with Google
  FutureEither<UserModel> signInWithGoogle(bool isFromLogin) async {
    try {
      UserCredential userCredential;

      // separate signIn mechanism for the Web
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider
            .addScope("https://www.googleapis.com/auth/contacts.readonly");
        userCredential = await _firebaseAuth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        final googleAuth = await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        if (isFromLogin) {
          userCredential =
              await _firebaseAuth.currentUser!.linkWithCredential(credential);
        } else {
          userCredential = await _firebaseAuth.signInWithCredential(credential);
        }
      }

      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? "No name",
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          karma: 0,
          awards: [
            'awesomeAns',
            'gold',
            'platinum',
            'til',
            'thankyou',
            'rocket',
            'plusone'
          ],
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (E) {
      throw E.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInAsGuest() async {
    try {
      var userCredential = await _firebaseAuth.signInAnonymously();
      UserModel userModel;

      userModel = UserModel(
        name: "Guest",
        profilePic: Constants.avatarDefault,
        banner: Constants.bannerDefault,
        uid: userCredential.user!.uid,
        isAuthenticated: false,
        karma: 0,
        awards: [],
      );
      await _users.doc(userCredential.user!.uid).set(userModel.toMap());

      userModel = await getUserData(userCredential.user!.uid).first;

      return right(userModel);
    } on FirebaseException catch (E) {
      throw E.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
