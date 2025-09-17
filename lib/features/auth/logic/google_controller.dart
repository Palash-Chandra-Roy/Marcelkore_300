import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _logger = Logger();

class GoogleAuthController extends StateNotifier<AsyncValue<void>> {
  GoogleAuthController() : super(const AsyncData(null));

  final SupabaseClient supabase = Supabase.instance.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email'],
      serverClientId: "103207095005-3ev2esf09jv8d8ef7fmg16dpnsl50l2s.apps.googleusercontent.com");

  /// Google Sign In
  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();

    try {
      _logger.i("🔹 Starting Google Sign-In...");

      var googleUser = await _googleSignIn.signInSilently();
      googleUser ??= await _googleSignIn.signIn();

      if (googleUser == null) {
        _logger.w("⚠️ Google Sign-In cancelled by user");
        state = const AsyncError("Cancelled by user", StackTrace.empty);
        return;
      }

      _logger.i("✅ Google user: ${googleUser.displayName} (${googleUser.email})");

      final googleAuth = await googleUser.authentication;

      if (googleAuth.idToken == null) {
        _logger.e("❌ Google Auth failed: idToken is null");
        state = const AsyncError("Google Auth failed", StackTrace.empty);
        return;
      }

      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      final user = response.user;
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("user_id", user.id);
        await prefs.setString("user_email", user.email ?? "");

        _logger.i("🎉 Supabase login success → ${user.email}");
        state = const AsyncData(null);
      } else {
        state = const AsyncError("Sign-in failed", StackTrace.empty);
      }
    } catch (e, st) {
      _logger.e("🔥 Error during Google Sign-In", error: e, stackTrace: st);
      state = AsyncError(e, st);
    }
  }



  /// Sign Out
  // Future<void> signOut() async {
  //   await supabase.auth.signOut();
  //   await _googleSignIn.signOut();
  //
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove("user_id");
  //   await prefs.remove("user_email");
  //
  //   _logger.i("👋 Signed out from Google + Supabase, prefs cleared");
  // }
}

final googleAuthProvider =
StateNotifierProvider<GoogleAuthController, AsyncValue<void>>(
        (ref) => GoogleAuthController());