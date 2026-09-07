import 'user.dart';

class AuthSession {
  const AuthSession({
    required this.user,
    required this.token,
    required this.expiresIn,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) => AuthSession(
    user: User.fromJson(json['user'] as Map<String, dynamic>),
    token: json['token'] as String,
    expiresIn: Duration(seconds: (json['expiresIn'] as num).toInt()),
  );

  final User user;
  final String token;

  /// The API returns a lifetime but exposes no refresh endpoint, so this is
  /// carried for completeness please see the README for what production would do.
  final Duration expiresIn;
}
