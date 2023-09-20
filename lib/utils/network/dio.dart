import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// class DioClient {
//   final apiUrl = dotenv.get("API_URL");
//   final baseUrl = "https://$apiUrl";
//   final Dio client = Dio(BaseOptions(
//       baseUrl: baseUrl,
//       connectTimeout: const Duration(seconds: 60),
//       receiveTimeout: const Duration(seconds: 60),
//       responseType: ResponseType.json));
// }

class DioClient {
  final String baseUrl;
  final Dio client;

  DioClient()
      : baseUrl =
            "https://${dotenv.env['API_URL']}", // Load the API_URL from .env
        client = Dio(BaseOptions(
          baseUrl: "https://${dotenv.env['API_URL']}",
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          responseType: ResponseType.json,
        ));
}
