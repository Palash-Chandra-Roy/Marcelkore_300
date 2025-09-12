import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

class GoogleAuthController extends StateNotifier<AsyncValue<void>> {
  GoogleAuthController() : super(const AsyncData(null));

  final SupabaseClient supabase = Supabase.instance.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();

    try {
      _logger.i("🔹 Starting Google Sign-In...");

      // Step 1: Google popup
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _logger.w("⚠️ Google Sign-In cancelled by user");
        state = const AsyncError("Cancelled by user", StackTrace.empty);
        return;
      }
      _logger.i("✅ Google user: ${googleUser.displayName} (${googleUser.email})");

      // Step 2: Token নেওয়া
      final googleAuth = await googleUser.authentication;
      _logger.i("🔑 Got tokens: idToken=${googleAuth.idToken != null}, accessToken=${googleAuth.accessToken != null}");

      // Step 3: Supabase এর সাথে Sign in
      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      if (response.user != null) {
        _logger.i("🎉 Supabase login success → ${response.user!.email}");
      } else {
        _logger.e("❌ Supabase login failed, no user returned");
      }

      state = const AsyncData(null);
    } catch (e, st) {
      _logger.e("🔥 Error during Google Sign-In", error: e, stackTrace: st);
      state = AsyncError(e, st);
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
    await _googleSignIn.signOut();
    _logger.i("👋 Signed out from Google + Supabase");
  }
}

final googleAuthProvider =
StateNotifierProvider<GoogleAuthController, AsyncValue<void>>(
        (ref) => GoogleAuthController());