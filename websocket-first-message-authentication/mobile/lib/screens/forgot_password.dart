import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validators/form_validators.dart';

import '../../widgets/error_dialog.dart';
import '../providers/forgot_password_state.dart';
import '../providers/forgot_password_state_provider.dart';
import '../widgets/text_input_field.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  String _getButtonText(FormzSubmissionStatus status) {
    if (status.isInProgress) {
      return 'Requesting';
    } else if (status.isFailure) {
      return 'Failed';
    } else if (status.isSuccess) {
      return 'Done ✅';
    } else {
      return 'Request';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forgotPasswordState = ref.watch(forgotPasswordStateProvider);
    final submissionStatus = forgotPasswordState.submissionStatus;

    ref.listen<ForgotPasswordState>(
      forgotPasswordStateProvider,
      (previous, current) {
        if (current.submissionStatus.isFailure) {
          Navigator.of(context).pop();
          ErrorDialog.show(context, '${current.errorMessage}');
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('${current.errorMessage}'),
          //   ),
          // );
        }
      },
    );

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextInputField(
                hintText: 'Please enter your Email',
                errorText: Email.showEmailErrorMessage(
                    forgotPasswordState.email.error),
                onChanged: (email) {
                  ref
                      .read(forgotPasswordStateProvider.notifier)
                      .onEmailChange(email);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: submissionStatus.isInProgress
                        ? null
                        : () {
                            Navigator.of(context).pop();
                          },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: submissionStatus.isInProgress ||
                            submissionStatus.isSuccess
                        ? null
                        : () {
                            ref
                                .read(forgotPasswordStateProvider.notifier)
                                .forgotPassword();
                          },
                    child: Text(_getButtonText(submissionStatus)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
