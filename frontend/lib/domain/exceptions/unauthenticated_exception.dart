class UnauthenticatedException implements Exception {
  late String message = "";

  UnauthenticatedException({this.message = ""});

  @override
  String toString() {
    return 'UnauthenticatedException: $message';
  }
}
