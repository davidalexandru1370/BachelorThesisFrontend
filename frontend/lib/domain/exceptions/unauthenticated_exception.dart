class UnauthenticatedException implements Exception {
  final String message;

  UnauthenticatedException(this.message);

  @override
  String toString() {
    return 'UnauthenticatedException: $message';
  }
}
