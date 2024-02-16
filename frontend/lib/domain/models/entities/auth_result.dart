class AuthResult {
  final String token;

  AuthResult(this.token);

  static AuthResult fromJson(Map<String, dynamic> map) {
    return AuthResult(
      map['accessToken'],
    );
  }
}
