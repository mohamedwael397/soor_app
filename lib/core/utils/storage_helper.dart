import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soor_app/features/auth/data/models/user_model.dart';

class StorageHelper {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const _tokenKey = 'auth_token';
  static const _phoneKey = 'auth_phone';
  static const _userKey = 'auth_user';

  static Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  static String? getToken() => _prefs.getString(_tokenKey);

  static Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
  }

  static Future<void> clearPhone() async {
    await _prefs.remove(_phoneKey);
  }

  static Future<void> clearAll() async {
    await _prefs.clear();
  }

  static Future<void> savePhone(String phone) async {
    await _prefs.setString(_phoneKey, phone);
  }

  static String? getPhone() => _prefs.getString(_phoneKey);

  static Future<void> saveUser(UserModel user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
    // also keep phone/name separate for quick access
    if (user.phone != null) await savePhone(user.phone!);
  }

  static UserModel? getUser() {
    final s = _prefs.getString(_userKey);
    if (s == null) return null;
    try {
      final map = jsonDecode(s) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  static String getUserName() => getUser()?.name ?? 'مستخدم';
  static String getUserPhone() => getUser()?.phone ?? getPhone() ?? '';

  static bool get isLoggedIn =>
      getToken() != null && getToken()!.isNotEmpty;
}
