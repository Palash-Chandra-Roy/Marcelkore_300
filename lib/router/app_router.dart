import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/features/auth/screen/login_screen.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/main_app.dart';
import 'package:my_app/features/record/screen/record_form_screen.dart';
import 'package:my_app/screens/singup_screen.dart';
import 'package:my_app/widgets/global_snackbar.dart';
import 'error_screen.dart';
class AppRouter {
  static const String initial = LoginScreen.routeName;
  static final GoRouter appRouter = GoRouter(
      initialLocation:initial,
      errorBuilder: (context, state) {
        // go_router ≥ 14 exposes uri; older versions use state.location
        final String badPath = state.uri.toString() ?? state.uri.toString() ?? '';
        return CustomGoErrorPage(
          location: badPath,
          error: state.error,
          onRetry: () => context.go(initial),
          onReport: () {
            GlobalSnackBar.show(context, title: "We're sorry", message: "'Thanks, we'll look into this.'");
          },
        );
      },

      routes: <RouteBase>[
        GoRoute(
          path: SignUpScreen.routeName,
          name: SignUpScreen.routeName,
          builder: (context, state) =>  const SignUpScreen(),
        ),
        GoRoute(
          path: LoginScreen.routeName,
          name: LoginScreen.routeName,
          builder: (context, state) => const LoginScreen(),
        ), GoRoute(
          path: HomeScreen.routeName,
          name: HomeScreen.routeName,
          builder: (context, state) => const HomeScreen(),
        ),GoRoute(
          path: MainApp.routeName,
          name: MainApp.routeName,
          builder: (context, state) => const MainApp(),
        ),GoRoute(
          path: RecordFormScreen.routeName,
          name: RecordFormScreen.routeName,
          builder: (context, state) => const RecordFormScreen(),
        ),
      ]);
}