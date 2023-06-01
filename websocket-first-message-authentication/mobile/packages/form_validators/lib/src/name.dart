import 'package:formz/formz.dart';

enum NameValidationError { empty, invalid }

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure([super.value = '']) : super.pure();
  const Name.dirty([super.value = '']) : super.dirty();

  bool get showError {
    return !isPure && !isValid;
  }

  @override
  NameValidationError? validator(String value) {
    if (value.isEmpty) {
      return NameValidationError.empty;
    } else if (value.length < 3) {
      return NameValidationError.invalid;
    } else {
      return null;
    }
  }

  static String? showNameErrorMessage(NameValidationError? error) {
    switch (error) {
      case NameValidationError.empty:
        return 'Empty name';
      case NameValidationError.invalid:
        return 'Too short name';
      default:
        return null;
    }
  }
}
