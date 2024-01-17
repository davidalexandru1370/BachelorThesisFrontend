class ErrorDetails {
  final String message;
  final String code;

  ErrorDetails({required this.message, required this.code});

  factory ErrorDetails.fromJson(Map<String, dynamic> json) {
    return ErrorDetails(
      message: json['message'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'code': code,
      };
}
