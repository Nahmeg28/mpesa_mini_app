import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/user.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const SignedOut();

  Future<void> signIn(String pin) async {
    final session = await ref.read(authRepositoryProvider).signInWithPin(pin);
    state = Authenticated(session);
  }

  void signOut() => state = const SignedOut();
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

final currentUserProvider = Provider<User?>(
  (ref) => switch (ref.watch(authControllerProvider)) {
    Authenticated(:final session) => session.user,
    SignedOut() => null,
  },
);
