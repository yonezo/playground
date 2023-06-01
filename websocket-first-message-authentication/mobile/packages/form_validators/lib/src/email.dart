import 'package:formz/formz.dart';

enum EmailValidationError { empty, invalid }

const String _kEmailPattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure([super.value = '']) : super.pure();
  const Email.dirty([super.value = '']) : super.dirty();

  bool get showError {
    return !isPure && !isValid;
  }

  static final _regex = RegExp(_kEmailPattern);

  @override
  EmailValidationError? validator(String value) {
    if (_regex.hasMatch(value)) {
      return null;
    } else if (value.isEmpty) {
      return EmailValidationError.empty;
    } else {
      return EmailValidationError.invalid;
    }
  }

  static String? showEmailErrorMessage(EmailValidationError? error) {
    switch (error) {
      case EmailValidationError.empty:
        return 'Empty email';
      case EmailValidationError.invalid:
        return 'Invalid email';
      default:
        return null;
    }
  }
}
