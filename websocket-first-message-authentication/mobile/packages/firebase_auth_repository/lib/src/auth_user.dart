import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

@freezed
class AuthUser with _$AuthUser {
  const AuthUser._();

  const factory AuthUser({
    required String id,
    String? email,
    String? name,
    @Default(false) bool? emailVerified,
  }) = _AuthUser;

  static const empty = AuthUser(id: '');

  bool get isEmpty => this == AuthUser.empty;
}
