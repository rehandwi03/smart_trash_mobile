import 'package:dio/dio.dart';
import 'package:smart_trash_mobile/data/models/trash.dart';
import 'package:smart_trash_mobile/utils/network/dio.dart';
import 'package:smart_trash_mobile/utils/storage/shared_preferences.dart';

class TrashRepository {
  SharedPreferencesService p = SharedPreferencesService();

  Future<ReportPerDay> getReportPerDay() async {
    try {
      final String? accessToken = p.prefs.getString("access_token");
      final client = DioClient().client;

      if (accessToken != null) {
        client.options.headers["Authorization"] = "Bearer $accessToken";
      }
      final response = await client.get("/api/trash/history/day");

      return ReportPerDay(data: response.data["data"] as int);
    } on DioException catch (e) {
      print(e.response?.data);
      print(e.response?.statusCode);
      if (e.response?.statusCode != 200) {
        throw "Something wrong";
      }
    } catch (e) {
      print(e);
    }

    throw "Unexpected error";
  }

  Future<List<TrashHistory>> getHistories() async {
    try {
      final String? accessToken = p.prefs.getString("access_token");
      final client = DioClient().client;

      if (accessToken != null) {
        client.options.headers["Authorization"] = "Bearer $accessToken";
      }

      final response = await client.get("/api/trash/history");

      List<dynamic> listData = response.data["data"];

      List<TrashHistory> users =
          listData.map((json) => TrashHistory.fromJson(json)).toList();

      return users;
    } on DioException catch (e) {
      print(e.response?.statusCode);
      if (e.response?.statusCode != 200) {
        throw "Something wrong";
      }
    } catch (e) {
      print(e);
      print(e);
    }

    throw "Unexpected error";
  }

  Future<void> lockTrash() async {
    try {
      final String? accessToken = p.prefs.getString("access_token");
      final client = DioClient().client;

      if (accessToken != null) {
        client.options.headers["Authorization"] = "Bearer $accessToken";
      }

      final response = client.post('/trash/lock');
    } on DioException catch (e) {
      if (e.response?.statusCode != 200) {
        throw 'Something Wrong';
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> unlockTrash() async {
    try {
      final String? accessToken = p.prefs.getString("access_token");
      final client = DioClient().client;

      if (accessToken != null) {
        client.options.headers["Authorization"] = "Bearer $accessToken";
      }

      final response = client.post('/trash/unlock');
    } on DioException catch (e) {
      if (e.response?.statusCode != 200) {
        throw 'Something Wrong';
      }
    } catch (e) {
      print(e);
    }
  }
}
