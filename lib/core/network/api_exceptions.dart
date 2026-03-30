/// Базовое исключение для API
class ApiException implements Exception {
  final String message;
  final dynamic innerException;

  ApiException(this.message, [this.innerException]);

  @override
  String toString() => 'ApiException: $message, inner: $innerException';
}

/// Нет подключения к сети
class NoNetworkException extends ApiException {
  NoNetworkException(super.message, [super.innerException]);
}

/// Токен истёк или невалиден
class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message, [super.innerException]);
}

/// Ресурс не найден (404)
class NotFoundException extends ApiException {
  NotFoundException(super.message, [super.innerException]);
}
