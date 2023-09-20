import 'dart:math';

import 'package:dio/dio.dart';
import 'package:smart_trash_mobile/data/models/base_response.dart';
import 'package:smart_trash_mobile/data/models/login.dart';
import 'package:smart_trash_mobile/utils/network/dio.dart';

class LoginRepository {
  Future<LoginResponse> login(LoginRequest req) async {
    try {
      final response =
          await DioClient().client.post("/api/login", data: req.toJson());

      final token = LoginResponse.fromJson(response.data["data"]);

      return token;
    } on DioException catch (e) {
      print(e);
      if (e.response?.statusCode != 200) {
        throw "Something wrong";
      }
    } catch (e) {
      print(e);
    }

    throw "Unexpected error";
  }
}
