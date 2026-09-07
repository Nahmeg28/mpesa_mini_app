import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_exception.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_session.dart';

class AuthRepository {
  const AuthRepository(this._remote);

  final AuthRemoteDataSource _remote;

  Future<AuthSession> signInWithPin(String pin) async {
    final body = await _remote.login(pin);

    if (body['success'] != true) {
      // The mock rejects a bad PIN with USER_NOT_FOUND I handled it to show the PIN is wrong.
      final code = (body['error'] as Map<String, dynamic>?)?['code'];
      if (code == 'USER_NOT_FOUND') throw const InvalidPin();

      throw UnknownFailure(
        body['message'] as String? ?? 'Sign-in failed. Please try again.',
      );
    }

    return AuthSession.fromJson(body['data'] as Map<String, dynamic>);
  }
}

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(ref.watch(authRemoteDataSourceProvider)),
);
