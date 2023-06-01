import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthenticationRepository>(
  (_) => AuthenticationRepositoryImpl(),
);
