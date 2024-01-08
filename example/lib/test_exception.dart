class TestException implements Exception {
  TestException({
    required this.reason,
    this.stackTrace,
  });

  StackTrace? stackTrace;
  final String reason;
}
