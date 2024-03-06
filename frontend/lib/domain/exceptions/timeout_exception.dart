class TimeoutException extends Error {
  final String message;

  TimeoutException(this.message);

  @override
  String toString() {
    return 'TimeoutException: $message';
  }
}
