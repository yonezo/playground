import 'package:flutter/foundation.dart';
import 'package:form_validators/form_validators.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_state.freezed.dart';

@freezed
class ForgotPasswordState with _$ForgotPasswordState {
  const ForgotPasswordState._();

  factory ForgotPasswordState({
    @Default(Email.pure()) Email email,
    @Default(false) bool isValid,
    @Default(FormzSubmissionStatus.initial)
    FormzSubmissionStatus submissionStatus,
    String? errorMessage,
  }) = _ForgotPasswordState;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is ForgotPasswordState &&
          (identical(other.email, email) || other.email == email) &&
          (identical(other.isValid, isValid) || other.isValid == isValid) &&
          (identical(other.submissionStatus, submissionStatus) ||
              other.submissionStatus == submissionStatus));

  @override
  int get hashCode =>
      Object.hash(runtimeType, email, isValid, submissionStatus);
}
