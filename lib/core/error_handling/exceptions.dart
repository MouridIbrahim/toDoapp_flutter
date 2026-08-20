/// Base exception class for app errors
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AppException(this.message, {this.code, this.originalError});

  @override
  String toString() {
    if (code != null) {
      return '$runtimeType [$code]: $message';
    }
    return '$runtimeType: $message';
  }
}

/// Database related exceptions
class DatabaseException extends AppException {
  DatabaseException(super.message, {super.code, super.originalError});
}

/// Task related exceptions
class TaskException extends AppException {
  TaskException(super.message, {super.code, super.originalError});
}

/// Validation exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  ValidationException(super.message, {this.fieldErrors, super.code})
      : super(message, code: code);
}

/// Network exceptions (for future use)
class NetworkException extends AppException {
  NetworkException(super.message, {super.code, super.originalError});
}

/// Generic failure result for operations
class Failure {
  final String message;
  final String? code;
  final dynamic exception;

  Failure(this.message, {this.code, this.exception});

  @override
  String toString() => 'Failure[$code]: $message';
}
