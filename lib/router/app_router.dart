import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/features/auth/screen/login_screen.dart';
import 'package:my_app/features/auth/screen/splash_screen.dart';
import 'package:my_app/features/home/screen/home_screen.dart';
import 'package:my_app/main.dart';
import 'package:my_app/models/record_data.dart';
import 'package:my_app/screens/main_app.dart';
import 'package:my_app/features/record/screen/record_form_screen.dart';
import 'package:my_app/screens/record_details_screen.dart';
import 'package:my_app/screens/settings_screen.dart';
import 'package:my_app/screens/singup_screen.dart';
import 'package:my_app/utils/record_form_args.dart';
import 'package:my_app/widgets/global_snackbar.dart';
import 'error_screen.dart';
class AppRouter {
  static const String initial = SplashScreen.routeName;
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
          path: SplashScreen.routeName,
          name: SplashScreen.routeName,
          builder: (context, state) => const SplashScreen(),
        ),GoRoute(
          path: RecordFormScreen.routeName,
          name: RecordFormScreen.routeName,
          builder: (context, state) {
            final args = state.extra as RecordFormArgs?;
            return RecordFormScreen(
              isId: args?.id,
              title: args?.title,
              value: args?.value ,
              details: args?.details,
              status: args?.status,
            );
          },
        ),


        GoRoute(
          path: SettingsScreen.routeName,
          name: SettingsScreen.routeName,
          builder: (context, state) => const SettingsScreen(),
        ),GoRoute(
          path: RecordDetailsScreen.routeName,
          name: RecordDetailsScreen.routeName,
          builder: (context, state)  {
            final String? id = state.extra as String?;   // 👈 এখানে id nullable
            return RecordDetailsScreen(recordId: id ??"",);},
        ),
      ]);
}