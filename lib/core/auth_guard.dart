import 'package:shared_preferences/shared_preferences.dart';
Future<String?> _role() async => (await SharedPreferences.getInstance()).getString('role');
Future<String?> authGuardAny(_, __) async => (await _role()) == null ? '/login' : null;
Future<String?> authGuardCitizen(_, __) async => (await _role()) == 'citizen' ? null : '/login';
Future<String?> authGuardStaff(_, __) async => (await _role()) == 'staff' ? null : '/login';
Future<String?> authGuardAdmin(_, __) async => (await _role()) == 'admin' ? null : '/login';
