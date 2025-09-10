import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Google Sign-In Notifier (Riverpod)
class GoogleSignInNotifier extends StateNotifier<AsyncValue<void>> {
  GoogleSignInNotifier() : super(const AsyncData(null));

  final SupabaseClient supabase = Supabase.instance.client;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    // clientId: 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com', // iOS only
    serverClientId:
    '449392146096-qk9u3dee956p6sreg1d99b3hnclrns1t.apps.googleusercontent.com',
  );

  /// 🔹 Sign in with Google and authenticate with Supabase
  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      // Step 1: Google Sign-In
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        state = AsyncError("Google sign-in cancelled", StackTrace.current);
        return;
      }

      // Step 2: Get Google Auth tokens
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null || accessToken == null) {
        state = AsyncError("Google token not found", StackTrace.current);
        return;
      }

      // Step 3: Authenticate with Supabase using Google tokens
      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      // Step 4: Handle response
      if (response.user != null) {
        state = const AsyncData(null); // ✅ success
      } else {
        state = AsyncError("Google Sign-In failed", StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

/// ✅ Riverpod Provider for Google Sign-In
final googleSignInProvider =
StateNotifierProvider<GoogleSignInNotifier, AsyncValue<void>>(
      (ref) => GoogleSignInNotifier(),
);