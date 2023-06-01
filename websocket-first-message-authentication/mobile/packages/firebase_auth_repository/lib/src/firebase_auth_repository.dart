import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_user.dart';

class SignUpWithEmailAndPasswordFailure implements Exception {
  final String code;
  const SignUpWithEmailAndPasswordFailure(this.code);
}

class SignInWithEmailAndPasswordFailure implements Exception {
  final String code;
  const SignInWithEmailAndPasswordFailure(this.code);
}

class ForgotPasswordFailure implements Exception {
  final String code;
  const ForgotPasswordFailure(this.code);
}

class SignInWithGoogleFailure implements Exception {}

class SignOutFailure implements Exception {}

abstract class AuthenticationRepository {
  Stream<AuthUser> get user;
  Future<String> getIdToken();

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> forgotPassword({required String email});
  Future<bool?> signInWithGoogle();
  Future<void> signOut();
}

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthenticationRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  @override
  Stream<AuthUser> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null
          ? AuthUser.empty
          : AuthUser(
              id: firebaseUser.uid,
              email: firebaseUser.email,
              name: firebaseUser.displayName,
              emailVerified: firebaseUser.emailVerified);
    });
  }

  @override
  Future<String> getIdToken() {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return Future.error('User does not exist');
    }
    return user.getIdToken();
  }

  @override
  Future<void> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure(e.code);
    }
  }

  @override
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw SignInWithEmailAndPasswordFailure(e.code);
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ForgotPasswordFailure(e.code);
    }
  }

  @override
  Future<bool?> signInWithGoogle() async {
    try {
      final googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        throw SignInWithGoogleFailure();
      }
      final googleSignInAuth = await googleSignInAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuth.accessToken,
        idToken: googleSignInAuth.idToken,
      );
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential.additionalUserInfo?.isNewUser;
    } on FirebaseAuthException catch (_) {
      throw SignInWithGoogleFailure();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (_) {
      throw SignOutFailure();
    }
  }
}
