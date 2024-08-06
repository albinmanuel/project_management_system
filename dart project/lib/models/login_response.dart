class LoginResponse {
  final bool status;
  final String message;



  LoginResponse({required this.status, required this.message,});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      message: json['message'],

    );
  }
}
