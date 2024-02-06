class ApiConstants {
  static const String BASE_URL = String.fromEnvironment("env", defaultValue: "Development") == "Development"
      ? "http://10.0.2.2:8080/api"
      : "https://api.example.com";
}
