import 'package:dio/dio.dart';
import 'package:plant_app/const.dart';

class PlantsDioHelper {
  static late Dio _dio;

  PlantsDioHelper._();

  static void init() {
    _dio = Dio(BaseOptions(
        baseUrl: plantBaseUrl,
        receiveTimeout: const Duration(seconds: 90),
        headers: {'lang': 'ar', 'Content-Type': 'application/json'}));
  }

  static Future<Response> getUrls(
      {required String Url,
      Map<String, dynamic>? params,
      Map<String, dynamic>? body}) async {
    final response = await _dio.get(Url, queryParameters: params, data: body);

    return response;
  }
}
