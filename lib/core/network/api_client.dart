import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const apiBaseUrl =
    'https://api.mockfly.dev/mocks/5064738f-5131-4b0a-8909-ca1634e26c27';

Dio createApiClient() {
  final dio = Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,

      validateStatus: (status) => status != null && status < 500,
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  return dio;
}

final apiClientProvider = Provider<Dio>((ref) {
  final dio = createApiClient();
  ref.onDispose(dio.close);

  return dio;
});
