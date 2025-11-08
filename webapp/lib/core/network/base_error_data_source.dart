import 'package:dio/dio.dart';
import '../error/exceptions/app_exception.dart';
import '../error/exceptions/network_exception.dart';
import '../error/exceptions/server_exception.dart';
import 'api_response.dart';

abstract class BaseRemoteDataSource {
  final Dio dio;

  BaseRemoteDataSource(this.dio);

  PaginatedResponse<T> handlePaginatedResponse<T>(
      Response response,
      T Function(dynamic) fromJson,
      ) {
    validateResponse(response);

    try {
      return PaginatedResponse<T>.fromJson(
        response.data as Map<String, dynamic>,
        fromJson,
      );

    } catch (e) {
      throw ParseException(
        'Ошибка парсинга пагинированного ответа: ${e.toString()}',
      );
    }
  }

  T handleResponse<T>(
      Response response,
      T Function(dynamic) fromJson,
      ) {
    validateResponse(response);

    try {
      return fromJson(response.data);
    } catch (e) {
      throw ParseException(
        'Ошибка парсинга ответа: ${e.toString()}',
      );
    }
  }

  List<T> handleListResponse<T>(
      Response response,
      T Function(dynamic) fromJson,
      ) {
    validateResponse(response);

    try {
      final list = response.data as List;
      return list.map((item) => fromJson(item)).toList();
    } catch (e) {
      throw ParseException(
        'Ошибка парсинга списка: ${e.toString()}',
      );
    }
  }

  void validateResponse(Response response) {
    final statusCode = response.statusCode;

    if (statusCode == null || statusCode < 200 || statusCode >= 300) {
      throw ServerException.fromResponse(
        statusCode ?? 500,
        _extractErrorMessage(response),
      );
    }
  }

  String? _extractErrorMessage(Response response) {
    try {
      if (response.data is Map) {
        final data = response.data as Map<String, dynamic>;
        return data['message'] ??
            data['error'] ??
            data['status_message'];
      }
    } catch (_) {}

    return null;
  }

  AppException handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          'Превышено время ожидания (${error.type.name})',
        );

      case DioExceptionType.connectionError:
        return const NetworkException('Нет подключения к интернету');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _extractErrorMessage(error.response!);
        return ServerException.fromResponse(statusCode ?? 500, message);

      case DioExceptionType.cancel:
        return const ServerException('Запрос отменен');

      case DioExceptionType.badCertificate:
        return const ServerException(
          'Ошибка проверки SSL сертификата',
          code: 'SSL_ERROR',
        );

      default:
        if (error.message?.contains('SocketException') ?? false) {
          return const NetworkException('Нет подключения к интернету');
        }

        return ServerException(
          error.message ?? 'Неизвестная ошибка',
          code: 'UNKNOWN_ERROR',
        );
    }
  }

  Future<T> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
