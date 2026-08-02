class HttpError implements Exception {
  const HttpError({this.stackTrace, this.statusCode, this.message});
  final StackTrace? stackTrace;
  final String? message;
  final int? statusCode;

  @override
  String toString() {
    return "Error message: $message, \n stackTrace: $stackTrace";
  }
}

class MissingResponseError implements Exception {
  const MissingResponseError({required this.message});
  final String message;

  @override
  String toString() {
    return "Error message: $message";
  }
}

class GenericError implements Exception {
  const GenericError({this.stackTrace, this.statusCode, this.message});
  final StackTrace? stackTrace;
  final String? message;
  final int? statusCode;

  @override
  String toString() {
    return "Error message: $message, \n stackTrace: $stackTrace";
  }
}
