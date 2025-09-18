import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

final appleAuthProvider =
StateNotifierProvider<AppleAuthController, AsyncValue<void>>(
      (ref) => AppleAuthController(),
);

class AppleAuthController extends StateNotifier<AsyncValue<void>> {
  AppleAuthController() : super(const AsyncData(null));

  final supabase = Supabase.instance.client;

  Future<void> signInWithApple() async {
    state = const AsyncLoading();
    try {
      _logger.i("🔹 Step 1: Generating rawNonce...");
      final rawNonce = supabase.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();
      _logger.i("✅ rawNonce generated: $rawNonce");
      _logger.i("✅ hashedNonce generated: $hashedNonce");

      _logger.i("🔹 Step 2: Requesting Apple credentials...");
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );
      _logger.i("✅ Apple credential received: ${credential.toString()}");

      final idToken = credential.identityToken;
      if (idToken == null) {
        _logger.e("❌ ID Token not found in credential");
        throw const AuthException('Could not find ID Token');
      }
      _logger.i("✅ ID Token received: ${idToken.substring(0, 20)}...");

      _logger.i("🔹 Step 3: Signing in with Supabase...");
      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );
      _logger.i("✅ Supabase Auth Response: ${response.user?.id}");

      // ✅ Save user data
      final user = response.user;
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("user_id", user.id);
        await prefs.setString("user_email", user.email ?? "");
        _logger.i("✅ User saved in SharedPreferences (id=${user.id}, email=${user.email})");
      } else {
        _logger.w("⚠️ Supabase returned null user!");
      }

      state = const AsyncData(null);
      _logger.i("🎉 Apple Sign-In successful!");
    } catch (e, st) {
      _logger.e("❌ Apple Sign-In failed", error: e, stackTrace: st);
      state = AsyncError(e, st);
    }
  }
}

//
// import 'dart:io' show Platform;
// import 'dart:convert';
// import 'package:crypto/crypto.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:logger/logger.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// final _logger = Logger();
//
// final appleAuthProvider =
// StateNotifierProvider<AppleAuthController, AsyncValue<void>>(
//       (ref) => AppleAuthController(),
// );
//
// class AppleAuthController extends StateNotifier<AsyncValue<void>> {
//   AppleAuthController() : super(const AsyncData(null));
//
//   final supabase = Supabase.instance.client;
//
//   Future<void> signInWithApple() async {
//     state = const AsyncLoading();
//
//     try {
//       if (Platform.isIOS) {
//         // ✅ iOS → Native Sign in with Apple
//         _logger.i("🔹 iOS Apple Sign-In started...");
//         final rawNonce = supabase.auth.generateRawNonce();
//         final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();
//
//         final credential = await SignInWithApple.getAppleIDCredential(
//           scopes: [
//             AppleIDAuthorizationScopes.email,
//             AppleIDAuthorizationScopes.fullName,
//           ],
//           nonce: hashedNonce,
//         );
//
//         final idToken = credential.identityToken;
//         if (idToken == null) throw Exception("❌ No ID Token from Apple");
//
//         final response = await supabase.auth.signInWithIdToken(
//           provider: OAuthProvider.apple,
//           idToken: idToken,
//           nonce: rawNonce,
//         );
//
//         await _saveUser(response.user);
//         _logger.i("🎉 iOS Apple Sign-In success!");
//       }else if (Platform.isAndroid) {
//         // ✅ Android → OAuth Web Flow
//         _logger.i("🔹 Android Apple Sign-In started (OAuth flow)...");
//         await supabase.auth.signInWithOAuth(
//           OAuthProvider.apple,
//           redirectTo: "io.supabase.flutter://login-callback",
//         );
//       }
//
//       state = const AsyncData(null);
//     } catch (e, st) {
//       _logger.e("❌ Apple Sign-In failed", error: e, stackTrace: st);
//       state = AsyncError(e, st);
//     }
//   }
//
//   Future<void> _saveUser(User? user) async {
//     if (user == null) return;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString("user_id", user.id);
//     await prefs.setString("user_email", user.email ?? "");
//     _logger.i("✅ User saved in SharedPreferences (id=${user.id}, email=${user.email})");
//   }
// }