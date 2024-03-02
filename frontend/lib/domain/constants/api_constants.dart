class ApiConstants {
  static const String BASE_URL =
      String.fromEnvironment("env", defaultValue: "Development") ==
              "Development"
          ? "http://192.168.43.181:5176/api"
          : "https://api.example.com";
}
