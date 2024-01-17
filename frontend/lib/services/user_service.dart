import 'dart:convert';

import 'package:http/http.dart' as http;
import '../domain/constants/api_constants.dart';
import '../domain/models/entities/auth_result.dart';
import '../domain/models/entities/user_credentials.dart';

class UserService {
  static Future<AuthResult> login(UserCredentials userCredentials) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.BASE_URL}/user/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userCredentials),
    );

    if (response.statusCode == 200) {
      return AuthResult.fromJson(jsonDecode(response.body));
    } else {
      throw AuthResult("", "Failed to login", false);
    }
  }

  static Future<AuthResult> register(UserCredentials userCredentials) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.BASE_URL}/user/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userCredentials),
    );

    if (response.statusCode == 200) {
      return AuthResult.fromJson(jsonDecode(response.body));
    } else {
      throw AuthResult("", "Failed to register", false);
    }
  }
}
