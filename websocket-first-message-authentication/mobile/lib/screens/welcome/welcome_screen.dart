import 'package:flutter/material.dart';

import 'auth_switch_button.dart';
import 'signin_content.dart';
import 'signup_content.dart';
import 'slide_fade_switcher.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _showSignIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: SlideFadeSwitcher(
                    child: _showSignIn
                        ? const SignInContent()
                        : const SignUpContent()),
              ),
            ],
          ),
          AuthSwitchButton(
            showSignIn: _showSignIn,
            onTap: () {
              setState(() {
                _showSignIn = !_showSignIn;
              });
            },
          )
        ],
      ),
    );
  }
}
