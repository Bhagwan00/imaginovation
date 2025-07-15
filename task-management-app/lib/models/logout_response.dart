class LogoutResponse {
  final bool status;
  final String message;

  LogoutResponse({required this.status, required this.message});

  factory LogoutResponse.fromMap(Map<String, dynamic> json) => LogoutResponse(
        status: json["status"],
        message: json['message'],
      );
}
