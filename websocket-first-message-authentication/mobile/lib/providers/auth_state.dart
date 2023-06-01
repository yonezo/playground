import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState.authenticated(
    AuthUser user,
  ) = _AuthenticationStateAuthenticated;

  const factory AuthenticationState.unauthenticated() =
      _AuthenticationStateUnauthenticated;
}
