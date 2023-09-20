import 'package:dio/dio.dart';
import 'package:smart_trash_mobile/data/models/trash.dart';
import 'package:smart_trash_mobile/utils/network/dio.dart';

class TrashRepository {
  Future<List<TrashHistory>> getHistories() async {
    try {
      final response = await DioClient().client.get("/api/trash/history");

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
      final response = DioClient().client.post('/trash/lock');
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
      final response = DioClient().client.post('/trash/unlock');
    } on DioException catch (e) {
      if (e.response?.statusCode != 200) {
        throw 'Something Wrong';
      }
    } catch (e) {
      print(e);
    }
  }
}
