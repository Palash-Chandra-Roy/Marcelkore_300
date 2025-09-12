import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/features/auth/logic/check_login.dart';
import 'package:my_app/screens/main_app.dart';
 // 🔹 SharedPreferences helper
import 'login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const routeName = "/splashScreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 3)); 

    final loggedIn = await AuthStorage.isLoggedIn();

    if (!mounted) return;

    if (loggedIn) {
     context.push(MainApp.routeName);
    } else {
      context.push(LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.school, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 20),

            const Text(
              "My App",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),
            const CircularProgressIndicator(), // loading spinner
          ],
        ),
      ),
    );
  }
}