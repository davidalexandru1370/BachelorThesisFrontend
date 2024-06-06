class ApiConstants {
  static const String BASE_URL =
      String.fromEnvironment("env", defaultValue: "Development") ==
              "Development"
          ? "http://192.168.1.6:5176/api"
          : "https://api.example.com";

  static const String WEBSOCKET_URL = "http://192.168.1.6:5176/api";
}
