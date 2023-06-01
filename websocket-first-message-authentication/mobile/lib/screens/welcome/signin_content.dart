import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validators/form_validators.dart';

import '../../providers/signin_state.dart';
import '../../providers/signin_state_provider.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/text_input_field.dart';
import '../forgot_password.dart';
import 'auth_submit_button.dart';
import 'google_signin_button.dart';
import 'or_divider.dart';

class SignInContent extends ConsumerWidget {
  const SignInContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SignInState>(
      signInStateProvider,
      (previous, current) {
        if (current.submissionStatus.isInProgress) {
          LoadingSheet.show(context);
        } else if (current.submissionStatus.isFailure) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${current.errorMessage}'),
            ),
          );
        } else if (current.submissionStatus.isSuccess) {
          Navigator.of(context).pop();
        }
      },
    );

    return const Column(
      children: [
        Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(
          height: 32,
        ),
        _EmailField(),
        SizedBox(
          height: 16,
        ),
        _PasswordField(),
        _ForgotPasswordButton(),
        SizedBox(
          height: 24,
        ),
        _SignInButton(),
        OrDivider(),
        GoogleSignInButton(),
      ],
    );
  }
}

class _EmailField extends ConsumerWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInState = ref.watch(signInStateProvider);
    final showError = signInState.email.showError;
    final signInStateNotifier = ref.read(signInStateProvider.notifier);
    return TextInputField(
      hintText: 'Email',
      errorText: showError
          ? Email.showEmailErrorMessage(signInState.email.error)
          : null,
      onChanged: (email) => signInStateNotifier.onEmailChange(email),
    );
  }
}

class _PasswordField extends ConsumerWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInState = ref.watch(signInStateProvider);
    final showError = signInState.password.showError;
    final signInStateNotifier = ref.read(signInStateProvider.notifier);
    return TextInputField(
      hintText: 'Password',
      obscureText: true,
      errorText: showError
          ? Password.showPasswordErrorMessage(signInState.password.error)
          : null,
      onChanged: (password) => signInStateNotifier.onPasswordChange(password),
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => const ForgotPasswordScreen(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Forgot Password',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.error.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInButton extends ConsumerWidget {
  const _SignInButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInState = ref.watch(signInStateProvider);
    final isValidated = signInState.isValid;
    final signInStateNotifier = ref.read(signInStateProvider.notifier);
    return AuthSubmitButton(
      onTap: isValidated
          ? () => signInStateNotifier.signInWithEmailAndPassword()
          : null,
      title: 'Sign In',
    );
  }
}
