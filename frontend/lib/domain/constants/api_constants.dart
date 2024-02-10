class ApiConstants {
  static const String BASE_URL = String.fromEnvironment("env", defaultValue: "Development") == "Development"
      ? "http://172.30.48.1:5176/api"
      : "https://api.example.com";
}
