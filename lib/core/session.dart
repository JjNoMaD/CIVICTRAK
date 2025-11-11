import 'package:shared_preferences/shared_preferences.dart';

enum UserRole { citizen, staff, admin }

class Session {
  static const _kRole = 'role';

  static Future<void> saveRole(UserRole role) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kRole, role.name);
  }

  static Future<UserRole?> getRole() async {
    final sp = await SharedPreferences.getInstance();
    final v = sp.getString(_kRole);
    if (v == null) return null;
    return UserRole.values.firstWhere((e) => e.name == v, orElse: () => UserRole.citizen);
  }

  static Future<void> logout() async {
    final sp = await SharedPreferences.getInstance();
    await sp.clear();
  }
}
