import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_repository_provider.dart';

final googleSignInStateProvider =
    StateNotifierProvider<GoogleSignInStateNotifier, GoogleSignInState>(
  (ref) {
    return GoogleSignInStateNotifier(
      ref.watch(authRepositoryProvider),
    );
  },
);

enum GoogleSignInState {
  initial,
  loading,
  success,
  error,
}

class GoogleSignInStateNotifier extends StateNotifier<GoogleSignInState> {
  final AuthenticationRepository _authRepository;

  GoogleSignInStateNotifier(this._authRepository)
      : super(GoogleSignInState.initial);

  Future<void> signInWithGoogle() async {
    state = GoogleSignInState.loading;

    try {
      final isNewUser = await _authRepository.signInWithGoogle();

      if (isNewUser != null && isNewUser) {
        // white to database
        // call cloud firestore repository
      }

      state = GoogleSignInState.success;
    } on SignInWithGoogleFailure catch (_) {
      state = GoogleSignInState.error;
    }
  }
}
