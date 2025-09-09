import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/supabase_service.dart';
import '../utils/snackbar_utils.dart';
import 'app_controller.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var isGoogleLoading = false.obs;
  var isAppleLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> handleLogin() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      await SupabaseService.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // update AppController
      final appController = Get.find<AppController>();
      appController.handleLogin();
    } catch (e) {
      SnackBarUtils.showError(Get.context!, "Login failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleGoogleLogin() async {
    isGoogleLoading.value = true;
    try {
      await SupabaseService.signInWithGoogle();
      final appController = Get.find<AppController>();
      appController.handleLogin();
    } catch (e) {
      SnackBarUtils.showError(Get.context!, "Google login failed: $e");
    } finally {
      isGoogleLoading.value = false;
    }
  }

  Future<void> handleAppleLogin() async {
    isAppleLoading.value = true;
    try {
      // এখানে Apple এর জন্য আলাদা method করলে ভালো, এখন Google এর মতো রাখা হলো
      await SupabaseService.signInWithGoogle();
      final appController = Get.find<AppController>();
      appController.handleLogin();
    } catch (e) {
      SnackBarUtils.showError(Get.context!, "Apple login failed: $e");
    } finally {
      isAppleLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    if (emailController.text.isEmpty) {
      SnackBarUtils.showError(Get.context!, "Enter email first");
      return;
    }

    try {
      await SupabaseService.resetPassword(emailController.text.trim());
      SnackBarUtils.showSuccess(Get.context!, "Password reset link sent");
    } catch (e) {
      SnackBarUtils.showError(Get.context!, "Reset failed: $e");
    }
  }
}
