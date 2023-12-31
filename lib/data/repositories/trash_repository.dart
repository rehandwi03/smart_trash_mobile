import 'package:dio/dio.dart';
import 'package:smart_trash_mobile/data/models/trash.dart';
import 'package:smart_trash_mobile/utils/network/dio.dart';
import 'package:smart_trash_mobile/utils/storage/shared_preferences.dart';

class TrashRepository {
  SharedPreferencesService p = SharedPreferencesService();

  Future<List<TrashResponse>> getAllTrash() async {
    try {
      final String? accessToken = p.prefs.getString("access_token");
      final client = DioClient().client;

      if (accessToken != null) {
        client.options.headers["Authorization"] = "Bearer $accessToken";
      }
      final response = await client.get("/api/trash");

      List<dynamic> listData = response.data["data"];

      List<TrashResponse> res =
          listData.map((e) => TrashResponse.fromJson(e)).toList();

      return res;
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

  Future<List<TrashHistory>> getHistories(
      {DateTime? startDate, DateTime? endDate}) async {
    try {
      final String? accessToken = p.prefs.getString("access_token");
      final client = DioClient().client;

      if (accessToken != null) {
        client.options.headers["Authorization"] = "Bearer $accessToken";
      }

      print(startDate);
      print(endDate);

      if (startDate != null) {
        client.options.queryParameters["start_date"] = startDate;
      }

      if (endDate != null) {
        client.options.queryParameters["end_date"] = endDate;
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

      final response = client.post('/api/trash/lock');
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

      final response = client.post('/api/trash/unlock');
    } on DioException catch (e) {
      if (e.response?.statusCode != 200) {
        throw 'Something Wrong';
      }
    } catch (e) {
      print(e);
    }
  }
}
