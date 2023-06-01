import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'firebase_auth_repository_test.mocks.dart';

@GenerateMocks([FirebaseAuth, GoogleSignIn])
void main() {
  late MockFirebaseAuth firebaseAuth;
  late MockGoogleSignIn googleSignIn;
  late AuthenticationRepository repository;

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    googleSignIn = MockGoogleSignIn();
    repository = AuthenticationRepositoryImpl(
      firebaseAuth: firebaseAuth,
      googleSignIn: googleSignIn,
    );
  });

  group('AuthenticationRepository', () {
    test('Test signUpWithEmailAndPassword method', () async {
      when(firebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(
        FirebaseAuthException(code: 'account-exists-with-different-credential'),
      );

      expect(
        () async => await repository.signUpWithEmailAndPassword(
          email: 'example@example.com',
          password: 'example',
        ),
        // throwsA(isA<SignUpWithEmailAndPasswordFailure>()),
        throwsA(
          predicate((p0) =>
              p0 is SignUpWithEmailAndPasswordFailure &&
              p0.code == 'account-exists-with-different-credential'),
        ),
      );

      verify(firebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).called(1);
    });
  });
}
