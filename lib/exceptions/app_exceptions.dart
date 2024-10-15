abstract class AppException implements Exception {
  final String message;
  AppException(this.message);
}

class NetworkException extends AppException {
  NetworkException({String message = "A network error occurred"})
      : super(message);
}

class ServerException extends AppException {
  ServerException({String message = "A server error occurred"})
      : super(message);
}

class CacheException extends AppException {
  CacheException([String message = "A cache error occurred"]) : super(message);
}

class ValidationException extends AppException {
  ValidationException([String message = "A validation error occurred"])
      : super(message);
}
