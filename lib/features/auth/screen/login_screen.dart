import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as ref;
import 'package:my_app/features/auth/logic/google_controller.dart';
import 'package:my_app/features/auth/logic/login_controller.dart';
import 'package:my_app/features/home/screen/home_screen.dart';
import 'package:my_app/screens/main_app.dart';
import 'package:my_app/screens/singup_screen.dart';
import 'package:my_app/widgets/global_snackbar.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = "/loginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _emailController;
  late TextEditingController _passwordController;


  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    // final state = ref.watch(googleAuthProvider);
    // final controller = ref.read(googleAuthProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screenWidth < 600 ? double.infinity : 400,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.person,
                            color: Theme
                                .of(context)
                                .colorScheme
                                .onPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Welcome Back My App",
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineSmall,
                        ),
                        Text(
                          "Sign in to continue",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Email
                    Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme
                            .of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: _inputDecoration("Email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter your email";
                        }
                        if (!value.contains("@")) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme
                            .of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: _inputDecoration("Password"),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return "Password must be at least 6 chars";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Login Button
                    Consumer(
                      builder: (context, ref, _) {
                        final authState = ref.watch(authControllerProvider);
                        final isLoading = authState is AsyncLoading;

                        return ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            // 🔹 Call login from controller
                            await ref
                                .read(authControllerProvider.notifier)
                                .login(
                              email: _emailController.text.trim(),
                              password:
                              _passwordController.text.trim(),
                            );

                            // 🔹 Check latest state
                            final latest =
                            ref.read(authControllerProvider);

                            // ✅ Navigate on success
                            if (latest is AsyncData) {
                              if (context.mounted) {
                                context.go(MainApp.routeName);
                              }
                            }

                            // ❌ Show error
                            if (latest is AsyncError) {
                              final errorMsg = latest.error.toString();

                              if (errorMsg
                                  .contains("Email not confirmed")) {
                                GlobalSnackBar.show(
                                  context,
                                  title: "Please Verify",
                                  message:
                                  "⚠️ Confirm your email before login.",
                                  type: CustomSnackType.error,
                                );
                              } else {
                                GlobalSnackBar.show(
                                  context,
                                  title: "Login Failed",
                                  message: "❌ $errorMsg",
                                  type: CustomSnackType.error,
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          child: isLoading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text("Login"),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Theme
                                .of(context)
                                .colorScheme
                                .outline
                                .withOpacity(0.2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR CONTINUE WITH',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Theme
                                .of(context)
                                .colorScheme
                                .outline
                                .withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Google Login
                    Consumer(
                      builder: (context, ref, _) {
                        final googleState = ref.watch(googleAuthProvider);

                        ref.listen<AsyncValue<void>>(googleAuthProvider, (previous, next) {
                          if (next is AsyncData) {
                            // ✅ Success হলে home এ যাবে
                            context.go(MainApp.routeName);
                          }
                          if (next is AsyncError) {
                           GlobalSnackBar.show(context, title:"Error", message:"Login failed: ${next.error}",type: CustomSnackType.error);
                          }
                        });

                        final isLoading = googleState is AsyncLoading;

                        return OutlinedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                            await ref.read(googleAuthProvider.notifier).signInWithGoogle();
                          },
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : Row(
                                children: [
                                  Spacer() ,

                            Image.asset("assets/images/google.png", height: 25,
                                    width: 25,),
                                  SizedBox(width: 8,)      ,
                                  const Text("Continue with Google"),
                                  Spacer()
                                ],
                              ),
                        );
                      },
                    ),



                    const SizedBox(height: 16),

                    // Apple Login
                    // OutlinedButton(
                    //   onPressed: () {},
                    //   style: OutlinedButton.styleFrom(
                    //     padding: const EdgeInsets.symmetric(vertical: 14),
                    //   ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Image.asset("assets/images/apple.png", height: 25,
                    //         width: 25,),
                    //       SizedBox(width: 8,),
                    //       const Text("Continue with Apple"),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: 16),

                    // Forgot Password
                    TextButton(
                      onPressed: () {},
                      child: const Text("Forgot password?"),
                    ),
                    const SizedBox(height: 10),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don’t have an account? "),
                        TextButton(
                          onPressed: () {
                            context.push(SignUpScreen.routeName);
                          },
                          child: const Text("Sign Up"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF3F3F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}//////