import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

import '../models/user.dart';
import '../store/user_repository.dart';

class AuthProvider {
  AuthProvider(this.userRepository);

  final UserRepository userRepository;

  final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Stream<User> getUser() {
    return firebaseAuth.userChanges().transform(
          SwitchMapStreamTransformer<auth.User, User>(
            (user) => user == null
                ? Stream.value(null)
                : userRepository.getUser(user.uid).map(
                      (dbUser) => User(
                        id: user.uid,
                        name: user.displayName,
                        crewId: dbUser?.crew,
                      ),
                    ),
          ),
        );
  }

  bool get isAuthenticated {
    return firebaseAuth.currentUser != null;
  }

  Future<auth.UserCredential> signInWithGoogle() async {
    final account = await googleSignIn.signIn();
    final authentication = await account.authentication;

    final credential = auth.GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );

    return firebaseAuth.signInWithCredential(credential);
  }

  void signOut() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
  }
}
