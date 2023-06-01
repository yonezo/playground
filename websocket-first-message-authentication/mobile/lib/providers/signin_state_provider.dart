import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validators/form_validators.dart';

import 'auth_repository_provider.dart';
import 'signin_state.dart';

final signInStateProvider =
    StateNotifierProvider.autoDispose<SignInStateNotifier, SignInState>(
  (ref) => SignInStateNotifier(ref.watch(authRepositoryProvider)),
);

class SignInStateNotifier extends StateNotifier<SignInState> {
  final AuthenticationRepository _authenticationRepository;
  SignInStateNotifier(this._authenticationRepository) : super(SignInState());

  void onEmailChange(String value) {
    final email = Email.dirty(value);
    state = state.copyWith(
      email: email,
      isValid: Formz.validate([email, state.password]),
    );
  }

  void onPasswordChange(String value) {
    final password = Password.dirty(value);
    state = state.copyWith(
      password: password,
      isValid: Formz.validate([state.email, password]),
    );
  }

  void signInWithEmailAndPassword() async {
    assert(state.isValid);

    state = state.copyWith(submissionStatus: FormzSubmissionStatus.inProgress);
    try {
      await _authenticationRepository.signInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      state = state.copyWith(submissionStatus: FormzSubmissionStatus.success);
    } on SignInWithEmailAndPasswordFailure catch (e) {
      state = state.copyWith(
        submissionStatus: FormzSubmissionStatus.failure,
        errorMessage: e.code,
      );
    }
  }
}
