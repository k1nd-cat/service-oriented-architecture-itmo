import 'package:dio/dio.dart';

class ApiClient extends Interceptor {
  final Dio dio;

  ApiClient()
    : dio = Dio(
        BaseOptions(
          // baseUrl: 'http://158.160.85.230:9001/service1/api/v1',
          baseUrl: 'https://158.160.85.230:8443',
          connectTimeout: const Duration(seconds: 5),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
}
