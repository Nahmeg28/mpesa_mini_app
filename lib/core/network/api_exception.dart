sealed class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType($message)';
}

final class InvalidPin extends ApiException {
  const InvalidPin() : super('Incorrect PIN. Please try again.');
}

final class NetworkFailure extends ApiException {
  const NetworkFailure()
    : super('Cannot reach M-PESA. Check your connection and try again.');
}

final class ServerFailure extends ApiException {
  const ServerFailure(super.message, {this.statusCode});

  final int? statusCode;
}

final class UnknownFailure extends ApiException {
  const UnknownFailure([
    super.message = 'Something went wrong. Please try again.',
  ]);
}
