import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _keyUserId = "user_id";
  static const _keyEmail = "user_email";

  /// Save user info
  static Future<void> saveUser(String id, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, id);
    await prefs.setString(_keyEmail, email);
  }

  /// Get user id
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  /// Get email
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  /// Check logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_keyUserId);
    final email = prefs.getString(_keyEmail);
    return id != null && id.isNotEmpty && email != null && email.isNotEmpty;
  }

  /// Clear storage
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}