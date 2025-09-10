import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:my_app/features/auth/screen/login_screen.dart';
import 'package:my_app/widgets/global_snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpState {
  final bool isLoading;
  final String? error;

  const SignUpState({this.isLoading = false, this.error});

  SignUpState copyWith({bool? isLoading, String? error}) {
    return SignUpState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class SignUpController extends StateNotifier<SignUpState> {
  SignUpController() : super(const SignUpState());

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signUp(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        data: {"name": nameController.text.trim()},
      );

      Logger().i("Response: ${response.user}");

      if (response.user != null) {
        if (context.mounted) {
          GlobalSnackBar.show(context,
              title: "Sign up successfully",
              message: "✅ Account created! Please login.",
              type: CustomSnackType.success);
          context.push(LoginScreen.routeName);
        }
      } else {
        state = state.copyWith(error: "Sign up failed. Try again.");
      }
    } catch (e) {
      Logger().e(e);
      state = state.copyWith(error: e.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("")),
        );
        GlobalSnackBar.show(context,
            title: "Error",
            message: "❌ Error: $e",
            type: CustomSnackType.error);
      }
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final signUpProvider =
StateNotifierProvider<SignUpController, SignUpState>((ref) {
  return SignUpController();
});