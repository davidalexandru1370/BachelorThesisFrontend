class ErrorDetails {
  final String message;
  final String code;

  ErrorDetails({required this.message, required this.code});

  factory ErrorDetails.fromMap(Map<String, dynamic> map) {
    return ErrorDetails(
      message: map['message'],
      code: map['code'],
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'code': code,
      };

  @override
  String toString() {
    return 'Error details: \ncode: $code \n message: $message';
  }
}
