import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authControllerProvider =
StateNotifierProvider<AuthController, AsyncValue<void>>(
      (ref) => AuthController(),
);

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController() : super(const AsyncData(null));

  final _logger = Logger();

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        

        // 🔹 Save ID & Email to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("user_id", response.user!.id);
        await prefs.setString("user_email", response.user!.email ?? "");

        state = const AsyncData(null); // Success
      } else {
        _logger.w("⚠️ Login failed. No user found.");
        state = AsyncError("Login failed", StackTrace.current);
      }
    } on AuthException catch (e, st) {
      _logger.e("AuthException: ${e.message}");
      state = AsyncError(e.message, st);
    } catch (e, st) {
      _logger.e("Unexpected error: $e");
      state = AsyncError(e, st);
    }
  }

  Future<Map<String, String?>> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "id": prefs.getString("user_id"),
      "email": prefs.getString("user_email"),
    };
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("user_id");
    await prefs.remove("user_email");

    state = const AsyncData(null);
  }
}