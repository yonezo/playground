import 'dart:async';

import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_repository_provider.dart';
import 'auth_state.dart';

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthenticationState>(
  (ref) => AuthStateNotifier(ref.watch(authRepositoryProvider)),
);

final authUserProvider = Provider<AuthUser>(
  (ref) => ref.watch(authStateProvider).when(
        authenticated: (user) => user,
        unauthenticated: () => AuthUser.empty,
      ),
);

class AuthStateNotifier extends StateNotifier<AuthenticationState> {
  final AuthenticationRepository _authRepository;
  late final StreamSubscription _streamSubscription;

  AuthStateNotifier(this._authRepository)
      : super(const AuthenticationState.unauthenticated()) {
    _streamSubscription =
        _authRepository.user.listen((user) => _onUserChanged(user));
  }

  void _onUserChanged(AuthUser user) {
    if (user.isEmpty) {
      state = const AuthenticationState.unauthenticated();
    } else {
      state = AuthenticationState.authenticated(user);
    }
  }

  Future<void> signOut() async => _authRepository.signOut();

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
