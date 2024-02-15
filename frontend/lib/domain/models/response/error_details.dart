class ErrorDetails {
  final String message;
  final int code;

  ErrorDetails({required this.message, required this.code});

  factory ErrorDetails.fromMap(Map<String, dynamic> map) {
    return ErrorDetails(
      message: map['detail'],
      code: map['status'],
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
