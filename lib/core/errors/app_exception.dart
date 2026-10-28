sealed class AppException implements Exception {
  final String message;

  const AppException(this.message);
}

final class NetworkException extends AppException {
  const NetworkException(super.message);
}

final class TimeoutException extends AppException {
  const TimeoutException(super.message);
}

final class ServerException extends AppException {
  const ServerException(super.message);
}

final class UnknownException extends AppException {
  const UnknownException(super.message);
}
