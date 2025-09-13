import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:my_app/router/app_router.dart';
import 'package:my_app/theme/controller/dark_mode.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(

    url: 'https://fviknrqqekcgqwzmksrq.supabase.co',  // ✅ Replace with your Project URL
   anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ2aWtucnFxZWtjZ3F3em1rc3JxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzODU1ODIsImV4cCI6MjA3MTk2MTU4Mn0.9jc7NKCg8m7l_wFC54nakXiGhfJPSGq-Ts2w33Ko2MY',                     // ✅ Replace with your Anon Key

   );
  runApp(const ProviderScope(
    child: ScreenUtilInit(
      designSize: Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MyApp(),
    ),
  ));
}
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeControllerProvider);

    return MaterialApp.router(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.appRouter,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      //    ? ThemeMode.dark
     //     : ThemeMode.light,
    );
  }
}