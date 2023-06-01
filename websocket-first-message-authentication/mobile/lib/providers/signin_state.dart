import 'package:flutter/foundation.dart';
import 'package:form_validators/form_validators.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'signin_state.freezed.dart';

@freezed
class SignInState with _$SignInState {
  const SignInState._();

  factory SignInState({
    @Default(Email.pure()) Email email,
    @Default(Password.pure()) Password password,
    @Default(false) bool isValid,
    @Default(FormzSubmissionStatus.initial)
    FormzSubmissionStatus submissionStatus,
    String? errorMessage,
  }) = _SignInState;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is SignInState &&
          (identical(other.email, email) || other.email == email) &&
          (identical(other.password, password) || other.password == password) &&
          (identical(other.isValid, isValid) || other.isValid == isValid) &&
          (identical(other.submissionStatus, submissionStatus) ||
              other.submissionStatus == submissionStatus));

  @override
  int get hashCode =>
      Object.hash(runtimeType, email, password, isValid, submissionStatus);
}
