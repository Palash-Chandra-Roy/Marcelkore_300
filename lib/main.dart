// import 'package:flutter/material.dart';
// import 'package:my_app/screens/singup_screen.dart';
// import 'screens/login_screen.dart';
// import 'screens/main_app.dart';
// import 'models/record_all_model.dart';
// import 'theme/app_theme.dart';
// import 'utils/snackbar_utils.dart';

// // Import services for initialization
// // import 'services/api_service.dart';
// import 'services/supabase_service.dart';

// void main() async {
//   // Ensure Flutter binding is initialized for async operations
//   WidgetsFlutterBinding.ensureInitialized();

//    await SupabaseService.initialize(
//      );
  
//   // Initialize Supabase (will work with mock data if not configured)
  
  
//   // try {
//   //   await SupabaseService.initialize();
//   //   print('Supabase initialized successfully');
//   // } catch (e) {
//   //   print('Failed to initialize Supabase: $e');
//   //   print('Continuing with mock data...');
//   // }
  




//   // PLACEHOLDER: Any other initialization (API config, etc.)
//   // ApiService.initialize(); // If you have any initialization needed
  
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'My App',
//       theme: AppTheme.lightTheme,
//       darkTheme: AppTheme.darkTheme,
//       themeMode: ThemeMode.system,
//       home: const AppWrapper(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// enum Screen {
//   login,
//   signup,
//   home,
//   records,
//   recordForm,
//   recordDetails,
//   settings,
// }

// enum AppTab { home, records, settings }

// class AppWrapper extends StatefulWidget {
//   const AppWrapper({super.key});

//   @override
//   State<AppWrapper> createState() => _AppWrapperState();
// }

// class _AppWrapperState extends State<AppWrapper> {
//   Screen _currentScreen = Screen.login;
//   AppTab _currentTab = AppTab.home;
//   bool _isAuthenticated = false;
//   bool _showLogoutDialog = false;
//   Record? _selectedRecord;
//   Record? _editingRecord;

//   @override
//   void initState() {
//     super.initState();
//     _checkAuthState();
//   }

//   void _checkAuthState() {
//     // Check if user is already authenticated
//     setState(() {
//       _isAuthenticated = SupabaseService.isSignedIn;
//       if (_isAuthenticated) {
//         _currentScreen = Screen.home;
//       }
//     });
//   }

//   // Navigation handlers
//   void _handleLogin() {
//     setState(() {
//       _isAuthenticated = true;
//       _currentScreen = Screen.home;
//       _currentTab = AppTab.home;
//     });
//     SnackBarUtils.showSuccess(context, 'Successfully logged in!');
//   }

//   void _handleSignUp() {
//     // Don't auto-login after signup, redirect to login page instead
//     setState(() {
//       _currentScreen = Screen.login;
//     });
//     SnackBarUtils.showSuccess(context, 'Account created successfully! Please login now.');
//   }

//   void _handleLogout() async {
//     try {
//       await SupabaseService.signOut();
//       setState(() {
//         _isAuthenticated = false;
//         _currentScreen = Screen.login;
//         _currentTab = AppTab.home;
//         _showLogoutDialog = false;
//       });
//       SnackBarUtils.showSuccess(context, 'Logged out successfully');
//     } catch (e) {
//       SnackBarUtils.showError(context, 'Logout failed: $e');
//     }
//   }

//   void _handleTabChange(AppTab tab) {
//     setState(() {
//       _currentTab = tab;
//       switch (tab) {
//         case AppTab.home:
//           _currentScreen = Screen.home;
//           break;
//         case AppTab.records:
//           _currentScreen = Screen.records;
//           break;
//         case AppTab.settings:
//           _currentScreen = Screen.settings;
//           break;
//       }
//     });
//   }

//   // Record handlers
//   void _handleCreateRecord() {
//     setState(() {
//       _editingRecord = null;
//       _currentScreen = Screen.recordForm;
//     });
//   }

//   void _handleEditRecord(Record record) {
//     setState(() {
//       _editingRecord = record;
//       _currentScreen = Screen.recordForm;
//     });
//   }

//   void _handleViewRecord(Record record) {
//     setState(() {
//       _selectedRecord = record;
//       _currentScreen = Screen.recordDetails;
//     });
//   }

//   void _handleSaveRecord(Record record) {
//     if (_editingRecord != null) {
//       SnackBarUtils.showSuccess(context, 'Record updated successfully!');
//     } else {
//       SnackBarUtils.showSuccess(context, 'Record created successfully!');
//     }
//     setState(() {
//       _currentScreen = Screen.records;
//       _currentTab = AppTab.records;
//       _editingRecord = null;
//     });
//   }

//   void _handleDeleteRecord(String id) {
//     SnackBarUtils.showSuccess(context, 'Record deleted successfully');
//     if (_currentScreen == Screen.recordDetails) {
//       setState(() {
//         _currentScreen = Screen.records;
//         _currentTab = AppTab.records;
//       });
//     }
//   }

//   void _handleCancelForm() {
//     setState(() {
//       _currentScreen = Screen.records;
//       _currentTab = AppTab.records;
//       _editingRecord = null;
//     });
//   }

//   void _handleBackToRecords() {
//     setState(() {
//       _currentScreen = Screen.records;
//       _currentTab = AppTab.records;
//       _selectedRecord = null;
//     });
//   }

//   void _navigateToRecords() {
//     setState(() {
//       _currentTab = AppTab.records;
//       _currentScreen = Screen.records;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Show authentication screens
//     if (!_isAuthenticated) {
//       if (_currentScreen == Screen.signup) {
//         return SignUpScreen(
//           onSignUp: _handleSignUp,
//           onNavigateToLogin: () => setState(() => _currentScreen = Screen.login),
//         );
//       }
//       return LoginScreen(
//         onLogin: _handleLogin,
//         onNavigateToSignUp: () => setState(() => _currentScreen = Screen.signup),
//       );
//     }

//     return MainApp(
//       currentScreen: _currentScreen,
//       currentTab: _currentTab,
//       selectedRecord: _selectedRecord,
//       editingRecord: _editingRecord,
//       showLogoutDialog: _showLogoutDialog,
//       onTabChange: _handleTabChange,
//       onCreateRecord: _handleCreateRecord,
//       onEditRecord: _handleEditRecord,
//       onViewRecord: _handleViewRecord,
//       onDeleteRecord: _handleDeleteRecord,
//       onSaveRecord: _handleSaveRecord,
//       onCancelForm: _handleCancelForm,
//       onBackToRecords: _handleBackToRecords,
//       onNavigateToRecords: _navigateToRecords,
//       onShowLogoutDialog: () => setState(() => _showLogoutDialog = true),
//       onHideLogoutDialog: () => setState(() => _showLogoutDialog = false),
//       onLogout: _handleLogout,
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:my_app/screens/singup_screen.dart';
// import 'screens/login_screen.dart';
// import 'screens/main_app.dart';
// import 'models/record_all_model.dart';
// import 'theme/app_theme.dart';
// import 'utils/snackbar_utils.dart';
// import 'services/supabase_service.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SupabaseService.initialize(); // ✅ Supabase init
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'My App',
//       theme: AppTheme.lightTheme,
//       darkTheme: AppTheme.darkTheme,
//       themeMode: ThemeMode.system,
//       home: const AppWrapper(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// enum Screen { login, signup, home, records, recordForm, recordDetails, settings }
// enum AppTab { home, records, settings }

// class AppWrapper extends StatefulWidget {
//   const AppWrapper({super.key});
//   @override
//   State<AppWrapper> createState() => _AppWrapperState();
// }

// class _AppWrapperState extends State<AppWrapper> {
//   Screen _currentScreen = Screen.login;
//   AppTab _currentTab = AppTab.home;
//   bool _isAuthenticated = false;
//   bool _showLogoutDialog = false;
//   Record? _selectedRecord;
//   Record? _editingRecord;

//   @override
//   void initState() {
//     super.initState();
//     _checkAuthState();
//   }

//   void _checkAuthState() {
//     setState(() {
//       _isAuthenticated = SupabaseService.isSignedIn;
//       if (_isAuthenticated) _currentScreen = Screen.home;
//     });
//   }

//   // ----------------------
//   // AUTH HANDLERS
//   // ----------------------

//   void _handleLogin() {
//     setState(() {
//       _isAuthenticated = true;
//       _currentScreen = Screen.home;
//       _currentTab = AppTab.home;
//     });
//     SnackBarUtils.showSuccess(context, 'Successfully logged in!');
//   }

//   void _handleSignUp() {
//     setState(() => _currentScreen = Screen.login);
//     SnackBarUtils.showSuccess(context, 'Account created! Please login.');
//   }

//   void _handleLogout() async {
//     try {
//       await SupabaseService.signOut();
//       setState(() {
//         _isAuthenticated = false;
//         _currentScreen = Screen.login;
//         _currentTab = AppTab.home;
//         _showLogoutDialog = false;
//       });
//       SnackBarUtils.showSuccess(context, 'Logged out successfully');
//     } catch (e) {
//       SnackBarUtils.showError(context, 'Logout failed: $e');
//     }
//   }

//   // ----------------------
//   // UI FLOW
//   // ----------------------

//   @override
//   Widget build(BuildContext context) {
//     if (!_isAuthenticated) {
//       if (_currentScreen == Screen.signup) {
//         return SignUpScreen(
//           onSignUp: _handleSignUp,
//           onNavigateToLogin: () => setState(() => _currentScreen = Screen.login),
//         );
//       }
//       return LoginScreen(
//         onLogin: _handleLogin,
//         onNavigateToSignUp: () => setState(() => _currentScreen = Screen.signup),
//       );
//     }

//     return MainApp(
//       currentScreen: _currentScreen,
//       currentTab: _currentTab,
//       selectedRecord: _selectedRecord,
//       editingRecord: _editingRecord,
//       showLogoutDialog: _showLogoutDialog,
//       onTabChange: (tab) => setState(() {
//         _currentTab = tab;
//         _currentScreen = tab == AppTab.home
//             ? Screen.home
//             : tab == AppTab.records
//                 ? Screen.records
//                 : Screen.settings;
//       }),
//       onCreateRecord: () => setState(() {
//         _editingRecord = null;
//         _currentScreen = Screen.recordForm;
//       }),
//       onEditRecord: (record) => setState(() {
//         _editingRecord = record;
//         _currentScreen = Screen.recordForm;
//       }),
//       onViewRecord: (record) => setState(() {
//         _selectedRecord = record;
//         _currentScreen = Screen.recordDetails;
//       }),
//       onDeleteRecord: (_) => SnackBarUtils.showSuccess(context, 'Record deleted!'),
//       onSaveRecord: (_) => setState(() {
//         _currentScreen = Screen.records;
//         _currentTab = AppTab.records;
//         _editingRecord = null;
//       }),
//       onCancelForm: () => setState(() {
//         _currentScreen = Screen.records;
//         _currentTab = AppTab.records;
//         _editingRecord = null;
//       }),
//       onBackToRecords: () => setState(() {
//         _currentScreen = Screen.records;
//         _currentTab = AppTab.records;
//         _selectedRecord = null;
//       }),
//       onNavigateToRecords: () => setState(() {
//         _currentTab = AppTab.records;
//         _currentScreen = Screen.records;
//       }),
//       onShowLogoutDialog: () => setState(() => _showLogoutDialog = true),
//       onHideLogoutDialog: () => setState(() => _showLogoutDialog = false),
//       onLogout: _handleLogout,
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:my_app/router/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'controller/settings_controller.dart';
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
    final settings = ref.watch(settingsProvider);

    return MaterialApp.router(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.appRouter,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: settings.darkModeEnabled
          ? ThemeMode.dark
          : ThemeMode.light,
    );
  }
}