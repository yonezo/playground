import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/splash_state_provider.dart';
import '../widgets/fade_swicher.dart';
import 'messages.dart';
import 'splash.dart';
import 'welcome/welcome_screen.dart';

class RootScreen extends ConsumerStatefulWidget {
  const RootScreen({super.key});

  @override
  ConsumerState<RootScreen> createState() => RootScreenState();
}

class RootScreenState extends ConsumerState<RootScreen> {
  Widget _buildScreen(SplashState state) {
    switch (state) {
      case SplashState.loading:
        return const SplashScreen();
      case SplashState.unauthenticated:
        return const WelcomeScreen();
      case SplashState.authenticated:
        return const MessagesScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(splashStateProvider);
    return FadeSwitcher(child: _buildScreen(state));
  }
}
