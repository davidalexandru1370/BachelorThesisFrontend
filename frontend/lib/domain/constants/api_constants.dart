import 'dart:io';

class ApiConstants {
  static final Map<String, String> _environment = Platform.environment;
  static final String BASE_URL = String.fromEnvironment("name", defaultValue: "Development") == "Development"
      ? "http://172.22.0.1:8080/api"
      : "https://api.example.com";
}
