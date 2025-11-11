import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio dio = Dio(BaseOptions(baseUrl: dotenv.env['API_BASE_URL']!));
  ApiClient() {
    dio.interceptors.add(InterceptorsWrapper(onRequest: (o, h) async {
      final sp = await SharedPreferences.getInstance();
      final t = sp.getString('token');
      if (t != null) o.headers['Authorization'] = 'Bearer $t';
      h.next(o);
    }));
  }
}
