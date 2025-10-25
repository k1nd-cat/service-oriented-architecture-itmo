import 'package:dio/dio.dart';

class DioClient {
  late final Dio _dio;

  Dio get dio => _dio;

  DioClient(String baseUrl) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
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

class MovieServiceClient extends DioClient {
  MovieServiceClient() : super('http://localhost:9001/service1/api/v1');
}

class OscarServiceClient extends DioClient {
  OscarServiceClient() : super('http://localhost:9001/service2');
}