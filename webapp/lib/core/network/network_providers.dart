import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dio_client.dart';

part 'network_providers.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dioClient = DioClient();

  ref.onDispose(() {
    dioClient.dio.close();
  });

  return dioClient.dio;
}
