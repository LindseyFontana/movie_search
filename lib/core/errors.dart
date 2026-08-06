enum ErrorType { api, connection, unknow }

class Failure implements Exception {
  final StackTrace? stackTrace;
  final String? message;
  final int? statusCode;
  final ErrorType type;

  const Failure({
    this.stackTrace,
    this.statusCode,
    this.message,
    required this.type,
  });

  @override
  String toString() => "Error message: $message, \n stackTrace: $stackTrace";
}

class HttpError extends Failure {
  const HttpError({
    super.stackTrace,
    super.statusCode,
    super.message,
    super.type = ErrorType.api,
  });

  @override
  String toString() => "Error message: $message, \n stackTrace: $stackTrace";
}

class MissingResponseError extends Failure {
  const MissingResponseError({
    super.stackTrace,
    super.message,
    super.type = ErrorType.unknow,
  });

  @override
  String toString() => "Error message: $message";
}

class ConnectionError extends Failure {
  const ConnectionError({
    super.stackTrace,
    super.message,
    super.type = ErrorType.connection,
  });

  @override
  String toString() => "Error message: $message";
}

class GenericError extends Failure {
  const GenericError({
    super.stackTrace,
    super.message,
    super.type = ErrorType.unknow,
  });

  @override
  String toString() => "Error message: $message";
}
