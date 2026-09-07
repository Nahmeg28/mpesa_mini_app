import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> login(String pin) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/login',
        data: {'pin': pin},
      );

      final body = response.data;
      if (body == null) throw const UnknownFailure();

      return body;
    } on DioException catch (e) {
      throw _asApiException(e);
    }
  }
}

ApiException _asApiException(DioException e) => switch (e.type) {
  DioExceptionType.connectionTimeout ||
  DioExceptionType.sendTimeout ||
  DioExceptionType.receiveTimeout ||
  DioExceptionType.connectionError => const NetworkFailure(),
  DioExceptionType.badResponse => ServerFailure(
    'M-PESA is unavailable right now. Please try again shortly.',
    statusCode: e.response?.statusCode,
  ),
  _ => const UnknownFailure(),
};

final authRemoteDataSourceProvider = Provider(
  (ref) => AuthRemoteDataSource(ref.watch(apiClientProvider)),
);
