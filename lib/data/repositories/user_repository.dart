import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:smart_trash_mobile/data/models/user.dart';
import 'package:smart_trash_mobile/utils/network/dio.dart';
import 'package:smart_trash_mobile/utils/storage/shared_preferences.dart';

class UserRepository {
  SharedPreferencesService p = SharedPreferencesService();

  Future<List<UserResponse>> getAllUser() async {
    try {
      final String? accessToken = p.prefs.getString("access_token");
      final client = DioClient().client;

      if (accessToken != null) {
        client.options.headers["Authorization"] = "Bearer $accessToken";
      }

      final response = await client.get("/api/users");

      List<dynamic> listData = response.data["data"];

      List<UserResponse> users =
          listData.map((json) => UserResponse.fromJson(json)).toList();

      return users;
    } on DioException catch (e) {
      if (e.response?.statusCode != 200) {
        throw "Something wrong";
      }
    } catch (e) {
      print(e);
    }

    throw "Unexpected error";
  }

  addUser(UserAddRequest req) async {
    try {
      final String? accessToken = p.prefs.getString("access_token");
      final client = DioClient().client;

      if (accessToken != null) {
        client.options.headers["Authorization"] = "Bearer $accessToken";
      }

      final response = await client.post("/api/users", data: req.toJson());

      return;
    } on DioException catch (e) {
      if (e.response?.statusCode != 200) {
        throw "Something Wrong";
      }
    } catch (e) {
      print(e);
    }
  }

  deleteUser(UserDeleteRequest req) async {
    try {
      final String? accessToken = p.prefs.getString("access_token");
      final client = DioClient().client;

      if (accessToken != null) {
        client.options.headers["Authorization"] = "Bearer $accessToken";
      }

      final response = await client.delete("/api/users", data: req.toJson());

      return;
    } on DioException catch (e) {
      if (e.response?.statusCode != 200) {
        throw "Something Wrong";
      }
    } catch (e) {
      print(e);
    }
  }
}
