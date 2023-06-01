import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validators/form_validators.dart';

import 'auth_repository_provider.dart';
import 'signup_state.dart';

final signUpStateProvider =
    StateNotifierProvider.autoDispose<SignUpStateNotifier, SignUpState>(
  (ref) => SignUpStateNotifier(ref.watch(authRepositoryProvider)),
);

class SignUpStateNotifier extends StateNotifier<SignUpState> {
  final AuthenticationRepository _authenticationRepository;
  SignUpStateNotifier(this._authenticationRepository) : super(SignUpState());

  void onNameChange(String value) {
    final name = Name.dirty(value);
    state = state.copyWith(
      name: name,
      isValid: Formz.validate([
        name,
        state.email,
        state.password,
      ]),
    );
  }

  void onEmailChange(String value) {
    final email = Email.dirty(value);

    state = state.copyWith(
      email: email,
      isValid: Formz.validate(
        [
          state.name,
          email,
          state.password,
        ],
      ),
    );
  }

  void onPasswordChange(String value) {
    final password = Password.dirty(value);
    state = state.copyWith(
      password: password,
      isValid: Formz.validate(
        [
          state.name,
          state.email,
          password,
        ],
      ),
    );
  }

  void signUpWithEmailAndPassword() async {
    assert(state.isValid);

    state = state.copyWith(submissionStatus: FormzSubmissionStatus.inProgress);
    try {
      await _authenticationRepository.signUpWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      state = state.copyWith(submissionStatus: FormzSubmissionStatus.success);
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      state = state.copyWith(
        submissionStatus: FormzSubmissionStatus.failure,
        errorMessage: e.code,
      );
    }
  }
}
