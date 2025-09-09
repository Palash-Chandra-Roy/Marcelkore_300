import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/supabase_service.dart';
import '../utils/snackbar_utils.dart';
import 'app_controller.dart';

class SignUpController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // TextEditingControllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> handleSignUp() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final response = await SupabaseService.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
        name: nameController.text.trim(),
      );

      if (response.user != null) {
        SnackBarUtils.showSuccess(Get.context!, "Account created! Please login.");
        // Notify AppController to switch to login screen
        final appController = Get.find<AppController>();
        appController.currentScreen.value = Screen.login;
      }
    } catch (e) {
      SnackBarUtils.showError(Get.context!, "Sign up failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
