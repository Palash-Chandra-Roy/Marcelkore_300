import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

final appleAuthProvider =
StateNotifierProvider<AppleAuthController, AsyncValue<void>>(
      (ref) => AppleAuthController(),
);

class AppleAuthController extends StateNotifier<AsyncValue<void>> {
  AppleAuthController() : super(const AsyncData(null));

  final SupabaseClient supabase = Supabase.instance.client;

  /// Apple Sign-In Function
  Future<void> signInWithApple(BuildContext context) async {
    state = const AsyncLoading();

    try {
      // ✅ এটা শুধু bool return করে
      final success = await supabase.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: "myapp://login-callback/",
      );

      if (!success) {
        state = AsyncError("Apple login failed", StackTrace.current);
        return;
      }

      // ✅ login successful হলে currentUser থেকে user info নাও
      final user = supabase.auth.currentUser;
      if (user == null) {
        state = AsyncError("No user found", StackTrace.current);
        return;
      }

      // SharedPreferences এ data save
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("user_id", user.id);
      await prefs.setString("email", user.email ?? "");

      state = const AsyncData(null);

      // Navigate to Home
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, "/home");
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

}