import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_state_provider.dart';

enum SplashState {
  loading,
  authenticated,
  unauthenticated,
}

final delayedProvider = FutureProvider<void>(
  (ref) => Future.delayed(const Duration(milliseconds: 2000)),
);

final splashStateProvider = Provider<SplashState>(
  (ref) {
    final delayed = ref.watch(delayedProvider);
    final authState = ref.watch(authStateProvider);

    if (delayed is AsyncError || authState is AsyncError) {
      return SplashState.unauthenticated;
    } else if (delayed is AsyncLoading || authState is AsyncLoading) {
      return SplashState.loading;
    }

    return authState.when(
        authenticated: (_) => SplashState.authenticated,
        unauthenticated: () => SplashState.unauthenticated);
  },
);
