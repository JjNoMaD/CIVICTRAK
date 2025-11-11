import '../../../core/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final _api = ApiClient().dio;
  Future<void> login(String email, String password) async {
    final r = await _api.post('/auth/login', data: {'email': email, 'password': password});
    final sp = await SharedPreferences.getInstance();
    await sp.setString('token', r.data['token']);
    await sp.setString('role', r.data['role']); // citizen|staff|admin
  }
}
