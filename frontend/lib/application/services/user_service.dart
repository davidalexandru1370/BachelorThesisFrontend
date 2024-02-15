import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../../domain/constants/api_constants.dart';
import '../../domain/models/entities/auth_result.dart';
import '../../domain/models/entities/user_credentials.dart';
import '../../domain/models/response/error_details.dart';

class UserService {
  static final Logger _logger = Logger();

  static Future<AuthResult> login(UserCredentials userCredentials) async {
    _logger.log(Level.info, "Logging in user with email and password");
    final response = await http.post(
      Uri.parse('${ApiConstants.BASE_URL}/user/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userCredentials),
    );

    if (response.statusCode == 200) {
      _logger.log(Level.info, "User logged in successfully");
      return AuthResult.fromJson(jsonDecode(response.body));
    } else {
      var errorDetails = ErrorDetails.fromMap(jsonDecode(response.body));
      var message = errorDetails.message;
      _logger.log(Level.error, errorDetails);
      throw Exception(message);
    }
  }

  static Future<AuthResult> register(UserCredentials userCredentials) async {
    _logger.log(Level.info, "Registering user with email and password");
    final response = await http.post(
      Uri.parse('${ApiConstants.BASE_URL}/user/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userCredentials),
    );

    if (response.statusCode == 200) {
      _logger.log(Level.info, "User registered successfully");
      return AuthResult.fromJson(jsonDecode(response.body));
    } else {
      var errorDetails = ErrorDetails.fromMap(jsonDecode(response.body));
      var message = errorDetails.message;
      _logger.log(Level.error, errorDetails);
      throw Exception(message);
    }
  }

  static Future<void> registerWithGoogle(String token) async {
    _logger.log(Level.info, "Registering with google");
    final response = await http.post(
      Uri.parse('${ApiConstants.BASE_URL}/user/register/google'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode != 200) {
      var body = jsonDecode(response.body);
      var errorDetails = ErrorDetails.fromMap(body);
      _logger.log(Level.error, errorDetails.toString());
      throw Exception(errorDetails.message);
    }

    _logger.log(Level.info, "Registered with google successfully");
  }
}
