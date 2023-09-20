class UserResponse {
  int id;
  String email;
  bool isActive;

  UserResponse({required this.id, required this.email, required this.isActive});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
        id: json["id"], email: json["email"], isActive: json["is_active"]);
  }
}

class UserDeleteRequest {
  int id;

  UserDeleteRequest({required this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;

    return data;
  }
}

class UserAddRequest {
  String email;

  UserAddRequest({required this.email});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["email"] = email;

    return data;
  }
}
