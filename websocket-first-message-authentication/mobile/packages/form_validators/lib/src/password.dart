import 'package:formz/formz.dart';

enum PasswordValidationError { empty, invalid }

const String _kPasswordPattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure([super.value = '']) : super.pure();
  const Password.dirty([super.value = '']) : super.dirty();

  static final _regex = RegExp(_kPasswordPattern);

  bool get showError {
    return !isPure && !isValid;
  }

  @override
  PasswordValidationError? validator(String value) {
    if (_regex.hasMatch(value)) {
      return null;
    } else if (value.isEmpty) {
      return PasswordValidationError.empty;
    } else {
      return PasswordValidationError.invalid;
    }
  }

  static String? showPasswordErrorMessage(PasswordValidationError? error) {
    switch (error) {
      case PasswordValidationError.empty:
        return 'Empty password';
      case PasswordValidationError.invalid:
        return 'Invalid password';
      default:
        return null;
    }
  }
}
