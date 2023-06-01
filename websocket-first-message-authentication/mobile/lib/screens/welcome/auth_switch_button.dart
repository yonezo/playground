import 'package:flutter/material.dart';

import 'slide_fade_switcher.dart';

const _kTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  color: Colors.black54,
);

class AuthSwitchButton extends StatelessWidget {
  final bool showSignIn;
  final VoidCallback onTap;
  const AuthSwitchButton({
    super.key,
    required this.showSignIn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 30,
      child: GestureDetector(
        onTap: onTap,
        child: SlideFadeSwitcher(
          child: showSignIn
              ? const Text(
                  "Don't have account? Sign Up",
                  key: ValueKey('SignIn'),
                  style: _kTextStyle,
                )
              : const Text(
                  'Already have account? Sign In',
                  key: ValueKey('SignUp'),
                  style: _kTextStyle,
                ),
        ),
      ),
    );
  }
}
