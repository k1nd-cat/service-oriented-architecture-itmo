import 'app_exception.dart';

class NetworkException extends AppException {
  const NetworkException([super.message = 'Нет подключения к интернету']);
}

class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Время ожидания истекло']);
}

class ParseException extends AppException {
  const ParseException([super.message = 'Ошибка обработки данных']);
}
