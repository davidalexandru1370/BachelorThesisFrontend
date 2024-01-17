class AuthResult {
  final bool result;
  final String token;
  final String error;

  AuthResult(this.token, this.error, this.result);

  Map toJson() => {
        'result': result,
        'token': token,
        'error': error,
      };

  static AuthResult fromJson(Map<String, dynamic> json) {
    return AuthResult(
      json['token'],
      json['error'],
      json['result'],
    );
  }
}
