import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validators/form_validators.dart';

import 'auth_repository_provider.dart';
import 'forgot_password_state.dart';

final forgotPasswordStateProvider = StateNotifierProvider.autoDispose<
    ForgotPasswordStateNotifier, ForgotPasswordState>(
  (ref) => ForgotPasswordStateNotifier(
    ref.watch(authRepositoryProvider),
  ),
);

class ForgotPasswordStateNotifier extends StateNotifier<ForgotPasswordState> {
  final AuthenticationRepository _authRepository;

  ForgotPasswordStateNotifier(this._authRepository)
      : super(ForgotPasswordState());

  void onEmailChange(String value) {
    final email = Email.dirty(value);

    state = state.copyWith(
      email: email,
      isValid: Formz.validate(
        [email],
      ),
    );
  }

  void forgotPassword() async {
    assert(state.isValid);

    state = state.copyWith(submissionStatus: FormzSubmissionStatus.inProgress);
    try {
      await _authRepository.forgotPassword(email: state.email.value);
      state = state.copyWith(submissionStatus: FormzSubmissionStatus.success);
    } on ForgotPasswordFailure catch (e) {
      state = state.copyWith(
        submissionStatus: FormzSubmissionStatus.failure,
        errorMessage: e.code,
      );
    }
  }
}
