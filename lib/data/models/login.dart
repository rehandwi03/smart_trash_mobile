class LoginResponse {
  String? accessToken;
  String? refreshToken;

  LoginResponse({required this.accessToken, required this.refreshToken});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
  }
}

class LoginRequest {
  String? email;
  String? password;
  String deviceToken;

  LoginRequest(
      {required this.email, required this.password, required this.deviceToken});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["email"] = email;
    data["password"] = password;
    data["device_token"] = deviceToken;

    return data;
  }
}
