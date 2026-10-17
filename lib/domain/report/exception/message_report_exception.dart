enum MessageReportFailure {
  invalidRequest,
  forbidden,
  notFound,
  duplicate,
  expired,
  unknown,
}

class MessageReportException implements Exception {
  final MessageReportFailure failure;
  final String message;
  final int? statusCode;

  const MessageReportException({
    required this.failure,
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => message;
}
