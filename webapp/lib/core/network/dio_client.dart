import 'package:dio/dio.dart';

class DioClient {
  late final Dio _dio;

  Dio get dio => _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://158.160.85.230:8443',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) {
          return status != null && status >= 200 && status < 300;
        },
      ),
    );

    _dio.interceptors.addAll([]);
  }
}