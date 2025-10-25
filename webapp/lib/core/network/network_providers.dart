import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dio_client.dart';

part 'network_providers.g.dart';

@Riverpod(keepAlive: true)
Dio movieServiceDio(Ref ref) {
  final dioClient = MovieServiceClient();

  ref.onDispose(() {
    dioClient.dio.close();
  });

  return dioClient.dio;
}

@Riverpod(keepAlive: true)
Dio oscarServiceDio(Ref ref) {
  final dioClient = OscarServiceClient();

  ref.onDispose(() {
    dioClient.dio.close();
  });

  return dioClient.dio;
}
