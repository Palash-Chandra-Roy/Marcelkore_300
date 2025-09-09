import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/features/auth/logic/sing_up_controller.dart';


class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});
  static const routeName = "/signUpScreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signUpProvider);
    final controller = ref.read(signUpProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo / Title
                    Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(Icons.person_add,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                        const SizedBox(height: 24),
                        Text("Create Account",
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 8),
                        Text("Join us and start learning",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            )),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Name
                    TextFormField(
                      controller: controller.nameController,
                      decoration:
                      _inputDecoration("Enter your full name", "Full Name"),
                      validator: (v) =>
                      v == null || v.isEmpty ? "Enter your name" : null,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: controller.emailController,
                      decoration:
                      _inputDecoration("Enter your email", "Email"),
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Enter your email";
                        if (!v.contains("@")) return "Enter a valid email";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextFormField(
                      controller: controller.passwordController,
                      obscureText: true,
                      decoration:
                      _inputDecoration("Create a password", "Password"),
                      validator: (v) => v == null || v.length < 6
                          ? "Password must be at least 6 chars"
                          : null,
                    ),

                    const SizedBox(height: 24),

                    // Sign Up Button
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : () => controller.signUp(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          Theme.of(context).colorScheme.primary,
                          foregroundColor:
                          Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: state.isLoading
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : const Text("Sign Up"),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Already have account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            )),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Login",
                              style: TextStyle(
                                  color:
                                  Theme.of(context).colorScheme.primary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Text('Demo app with Supabase backend',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, String label) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF3F3F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}