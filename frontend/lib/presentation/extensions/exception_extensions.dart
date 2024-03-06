extension FormattedMessage on Exception {
  String get getMessage {
    var prefix = "Exception: ";
    if (toString().startsWith(prefix)) {
      return toString().substring(prefix.length);
    } else {
      return toString();
    }
  }
}
