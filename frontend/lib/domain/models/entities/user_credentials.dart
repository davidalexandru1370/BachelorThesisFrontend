class UserCredentials {
  String email;
  String password;

  UserCredentials({required this.email, required this.password});

  Map toJson() => {
        'email': email,
        'password': password,
      };
}
