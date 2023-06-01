import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/google_signin_provider.dart';
import '../../widgets/error_dialog.dart';
import 'animated_button.dart';

class GoogleSignInButton extends ConsumerWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<GoogleSignInState>(
      googleSignInStateProvider,
      (previous, current) {
        if (current == GoogleSignInState.loading) {
          LoadingSheet.show(context);
        } else if (current == GoogleSignInState.error) {
          Navigator.of(context).pop();
          ErrorDialog.show(context, 'Google signin failed');
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('Google signin failed'),
          //   ),
          // );
        } else if (current == GoogleSignInState.success) {
          Navigator.of(context).pop();
        }
      },
    );

    return AnimatedButton(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black.withOpacity(0.2),
              width: 1,
            )),
        child: const Text(
          'Sign In With Google',
          style: TextStyle(
            color: Color(0xFF9A9A9A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      onTap: () {
        ref.read(googleSignInStateProvider.notifier).signInWithGoogle();
      },
    );
  }
}
