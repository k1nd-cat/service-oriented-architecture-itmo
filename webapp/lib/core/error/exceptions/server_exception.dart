import 'app_exception.dart';

class ServerException extends AppException {
  final int? statusCode;

  const ServerException(
      super.message, {
        this.statusCode,
        super.code,
      });

  factory ServerException.fromResponse(int statusCode, String? message) {
    switch (statusCode) {
      case 400:
        return ServerException(
          message ?? 'Неверный запрос',
          statusCode: 400,
          code: 'BAD_REQUEST',
        );
      case 404:
        return ServerException(
          message ?? 'Ресурс не найден',
          statusCode: 404,
          code: 'NOT_FOUND',
        );
      case 500:
        return ServerException(
          message ?? 'Внутренняя ошибка сервера',
          statusCode: 500,
          code: 'INTERNAL_SERVER_ERROR',
        );
      default:
        return ServerException(
          message ?? 'Ошибка сервера',
          statusCode: statusCode,
          code: 'SERVER_ERROR',
        );
    }
  }
}