import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validators/form_validators.dart';

import '../../providers/signup_state.dart';
import '../../providers/signup_state_provider.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/text_input_field.dart';
import 'auth_submit_button.dart';

class SignUpContent extends ConsumerWidget {
  const SignUpContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SignUpState>(
      signUpStateProvider,
      (previous, current) {
        if (current.submissionStatus.isInProgress) {
          LoadingSheet.show(context);
        } else if (current.submissionStatus.isFailure) {
          Navigator.of(context).pop();
          ErrorDialog.show(context, '${current.errorMessage}');
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('${current.errorMessage}'),
          //   ),
          // );
        } else if (current.submissionStatus.isSuccess) {
          Navigator.of(context).pop();
        }
        // else if (current.submissionStatus.isSuccess) {
        //   Navigator.of(context).pop();
        // }
      },
    );

    return const Column(
      children: [
        Text(
          'Create Account',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          height: 32,
        ),
        _NameField(),
        SizedBox(
          height: 16,
        ),
        _EmailField(),
        SizedBox(
          height: 16,
        ),
        _PasswordField(),
        SizedBox(
          height: 24,
        ),
        _SignUpButton(),
      ],
    );
  }
}

class _EmailField extends ConsumerWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpState = ref.watch(signUpStateProvider);
    final showError = signUpState.email.showError;
    final signUpStateNotifier = ref.read(signUpStateProvider.notifier);
    return TextInputField(
      hintText: 'Email',
      errorText: showError
          ? Email.showEmailErrorMessage(signUpState.email.error)
          : null,
      onChanged: (email) => signUpStateNotifier.onEmailChange(email),
    );
  }
}

class _NameField extends ConsumerWidget {
  const _NameField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpState = ref.watch(signUpStateProvider);
    final showError = signUpState.name.showError;
    final signUpStateNotifier = ref.read(signUpStateProvider.notifier);
    return TextInputField(
      hintText: 'Name',
      errorText:
          showError ? Name.showNameErrorMessage(signUpState.name.error) : null,
      onChanged: (name) => signUpStateNotifier.onNameChange(name),
    );
  }
}

class _PasswordField extends ConsumerWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpState = ref.watch(signUpStateProvider);
    final showError = signUpState.password.showError;
    final signUpStateNotifier = ref.read(signUpStateProvider.notifier);
    return TextInputField(
      hintText: 'Password',
      obscureText: true,
      errorText: showError
          ? Password.showPasswordErrorMessage(signUpState.password.error)
          : null,
      onChanged: (password) => signUpStateNotifier.onPasswordChange(password),
    );
  }
}

class _SignUpButton extends ConsumerWidget {
  const _SignUpButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpState = ref.watch(signUpStateProvider);
    final signUpStateNotifier = ref.read(signUpStateProvider.notifier);
    final isValidated = signUpState.isValid;
    return AuthSubmitButton(
      onTap: isValidated
          ? () => signUpStateNotifier.signUpWithEmailAndPassword()
          : null,
      title: 'Sign Up',
    );
  }
}
