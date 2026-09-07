import '../../../data/models/auth_session.dart';

sealed class AuthState {
  const AuthState();
}

final class SignedOut extends AuthState {
  const SignedOut();
}

final class Authenticated extends AuthState {
  const Authenticated(this.session);

  final AuthSession session;
}
