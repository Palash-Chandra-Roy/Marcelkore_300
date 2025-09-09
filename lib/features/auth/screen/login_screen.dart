import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/features/auth/logic/login_controller.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/singup_screen.dart';
import '../../../screens/debug_screen.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
  });
  static const routeName = "/loginScreen" ;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    GlobalKey formKey = GlobalKey() ;
    TextEditingController _emailController = TextEditingController() ;
    TextEditingController _passwordController = TextEditingController() ;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth < 600 ? double.infinity : 400,
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(Icons.person,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                        const SizedBox(height: 16),
                        Text("Welcome Back My App",
                            style: Theme.of(context).textTheme.headlineSmall),
                        Text("Sign in to continue",
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email
                  Text("Email",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      )),
                  TextFormField(
                    controller: _emailController,
                    decoration: _inputDecoration("Email"),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Enter your email";
                      if (!value.contains("@")) return "Enter a valid email";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  Text("Password",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      )),
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
                    await ref.read(authControllerProvider.notifier).login(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    );

                    // ✅ Navigate on success
                    final latest = ref.read(authControllerProvider);
                    if (latest is AsyncData) {
                    context.push(HomeScreen.routeName) ;
                    }

                    // ❌ Show error
                    if (latest is AsyncError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("❌ ${latest.error}")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR CONTINUE WITH',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Google Login
                  OutlinedButton(
                        onPressed:  (){},
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14)),
                        child: const Text("Continue with Google"),
                      ),
                  const SizedBox(height: 16),

                  // Apple Login
                    OutlinedButton(
                        onPressed: (){},
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14)),
                        child:const Text("Continue with Apple"),
                      ),
                  const SizedBox(height: 16),

                  // Forgot Password
                  TextButton(
                    onPressed: (){},
                    child: const Text("Forgot password?"),
                  ),
                  const SizedBox(height: 10),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don’t have an account? "),
                      TextButton(
                        onPressed: (){context.push(SignUpScreen.routeName);},
                        child: const Text("Sign Up"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Footer
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DebugScreen()),
                          );
                        },
                        child: Text(
                          'Debug Connection',
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.7),
                          ),
                        ),
                      ),
                      Text(
                        'Demo app with Supabase backend',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ],
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
}