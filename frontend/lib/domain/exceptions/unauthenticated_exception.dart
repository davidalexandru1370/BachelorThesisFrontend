class UnauthenticatedException extends Error {
  final String message;

  UnauthenticatedException(this.message);

  @override
  String toString() {
    return 'UnauthenticatedException: $message';
  }
}
