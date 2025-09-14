// // import 'package:flutter/material.dart';
// // import '../services/supabase_service.dart';
//
// // class DebugScreen extends StatefulWidget {
// //   const DebugScreen({super.key});
//
// //   @override
// //   State<DebugScreen> createState() => _DebugScreenState();
// // }
//
// // class _DebugScreenState extends State<DebugScreen> {
// //   final _testEmailController = TextEditingController();
// //   final _testPasswordController = TextEditingController();
// //   bool _isLoading = false;
// //   String _debugInfo = '';
//
// //   @override
// //   void initState() {
// //     super.initState();
// //     _checkSupabaseStatus();
// //   }
//
// //   void _checkSupabaseStatus() {
// //     setState(() {
// //       _debugInfo = '''
// // Debug Information:
// // - Supabase Configured: ${SupabaseService.isConfigured}
// // - User Signed In: ${SupabaseService.isSignedIn}
// // - Current User: ${SupabaseService.currentUser?.email ?? 'None'}
// // - Supabase URL: ${SupabaseService.SUPABASE_URL}
// // ''';
// //     });
// //   }
//
// //   Future<void> _testSignUp() async {
// //     setState(() => _isLoading = true);
//
// //     try {
// //       final email = _testEmailController.text.trim();
// //       final password = _testPasswordController.text.trim();
//
// //       if (email.isEmpty || password.isEmpty) {
// //         throw Exception('Please enter both email and password');
// //       }
//
// //       print('Testing signup with: $email');
//
// //       final response = await SupabaseService.signUp(email, password);
//
// //       setState(() {
// //         _debugInfo += '\n✅ Sign Up Success: ${response.user?.email}';
// //         _debugInfo += '\n   User ID: ${response.user?.id}';
// //         _debugInfo += '\n   Email Confirmed: ${response.user?.emailConfirmedAt != null}';
// //       });
//
// //     } catch (e) {
// //       setState(() {
// //         _debugInfo += '\n❌ Sign Up Failed: $e';
// //       });
// //     } finally {
// //       setState(() => _isLoading = false);
// //     }
// //   }
//
// //   Future<void> _testSignIn() async {
// //     setState(() => _isLoading = true);
//
// //     try {
// //       final email = _testEmailController.text.trim();
// //       final password = _testPasswordController.text.trim();
//
// //       if (email.isEmpty || password.isEmpty) {
// //         throw Exception('Please enter both email and password');
// //       }
//
// //       print('Testing signin with: $email');
//
// //       final response = await SupabaseService.signIn(email, password);
//
// //       setState(() {
// //         _debugInfo += '\n✅ Sign In Success: ${response.user?.email}';
// //         _debugInfo += '\n   User ID: ${response.user?.id}';
// //         _debugInfo += '\n   Email Confirmed: ${response.user?.emailConfirmedAt != null}';
// //       });
//
// //     } catch (e) {
// //       setState(() {
// //         _debugInfo += '\n❌ Sign In Failed: $e';
// //       });
// //     } finally {
// //       setState(() => _isLoading = false);
// //     }
// //   }
//
// //   Future<void> _testSignOut() async {
// //     setState(() => _isLoading = true);
//
// //     try {
// //       await SupabaseService.signOut();
// //       setState(() {
// //         _debugInfo += '\n✅ Sign Out Success';
// //       });
// //       _checkSupabaseStatus();
// //     } catch (e) {
// //       setState(() {
// //         _debugInfo += '\n❌ Sign Out Failed: $e';
// //       });
// //     } finally {
// //       setState(() => _isLoading = false);
// //     }
// //   }
//
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Debug Supabase'),
// //         backgroundColor: Theme.of(context).colorScheme.primary,
// //         foregroundColor: Theme.of(context).colorScheme.onPrimary,
// //       ),
// //       body: SimpleDialogOption(
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               // Debug Info
// //               Container(
// //                 padding: const EdgeInsets.all(12),
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey[100],
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 child: Text(
// //                   _debugInfo,
// //                   style: const TextStyle(
// //                     fontFamily: 'monospace',
// //                     fontSize: 12,
// //                   ),
// //                 ),
// //               ),
//
// //               const SizedBox(height: 20),
//
// //               // Test Email
// //               TextField(
// //                 controller: _testEmailController,
// //                 decoration: const InputDecoration(
// //                   labelText: 'Test Email',
// //                   border: OutlineInputBorder(),
// //                   hintText: 'test@example.com',
// //                 ),
// //                 keyboardType: TextInputType.emailAddress,
// //               ),
//
// //               const SizedBox(height: 12),
//
// //               // Test Password
// //               TextField(
// //                 controller: _testPasswordController,
// //                 decoration: const InputDecoration(
// //                   labelText: 'Test Password',
// //                   border: OutlineInputBorder(),
// //                   hintText: 'password123',
// //                 ),
// //                 obscureText: true,
// //               ),
//
// //               const SizedBox(height: 20),
//
// //               // Action Buttons
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: ElevatedButton(
// //                       onPressed: _isLoading ? null : _testSignUp,
// //                       child: const Text('Test Sign Up'),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 12),
// //                   Expanded(
// //                     child: ElevatedButton(
// //                       onPressed: _isLoading ? null : _testSignIn,
// //                       child: const Text('Test Sign In'),
// //                     ),
// //                   ),
// //                 ],
// //               ),
//
// //               const SizedBox(height: 12),
//
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: ElevatedButton(
// //                       onPressed: _isLoading ? null : _testSignOut,
// //                       child: const Text('Test Sign Out'),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 12),
// //                   Expanded(
// //                     child: ElevatedButton(
// //                       onPressed: () {
// //                         setState(() => _debugInfo = '');
// //                         _checkSupabaseStatus();
// //                       },
// //                       child: const Text('Refresh'),
// //                     ),
// //                   ),
// //                 ],
// //               ),
//
// //               const SizedBox(height: 12),
//
// //               // Quick Setup Button
// //               ElevatedButton(
// //                 onPressed: _isLoading ? null : () {
// //                   setState(() {
// //                     _testEmailController.text = 'palashtp21@gmail.com';
// //                     _testPasswordController.text = 'password123';
// //                     _debugInfo += '\n📝 Test credentials filled:\nEmail: palashtp21@gmail.com\nPassword: password123\n';
// //                   });
// //                 },
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.blue,
// //                   foregroundColor: Colors.white,
// //                 ),
// //                 child: const Text('Fill Test Credentials'),
// //               ),
//
// //               const SizedBox(height: 8),
//
// //               // Quick Fix Button
// //               Container(
// //                 width: double.infinity,
// //                 child: ElevatedButton(
// //                   onPressed: () {
// //                     setState(() {
// //                       _debugInfo += '''
//
// //         🔧 QUICK FIX INSTRUCTIONS:
//
// //         1. Go to Supabase Dashboard:
// //            https://supabase.com/dashboard
//
// //         2. Select your project: fviknrqqekcgqwzmksrq
//
// //         3. Go to Authentication → Settings → General
//
// //         4. Turn OFF "Enable email confirmations"
//
// //         5. Click Save
//
// //         6. Come back and try login again!
//
// //         Alternative: Create account first, then login:
// //         - Click "Fill Test Credentials" above
// //         - Click "Test Sign Up"
// //         - Then click "Test Sign In"
// //         ''';
// //                     });
// //                   },
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.orange,
// //                     foregroundColor: Colors.white,
// //                   ),
// //                   child: const Text('🔧 Show Quick Fix Guide'),
// //                 ),
// //               ),
//
// //               if (_isLoading)
// //                 const Padding(
// //                   padding: EdgeInsets.all(20.0),
// //                   child: Center(child: CircularProgressIndicator()),
// //                 ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
//
// //   @override
// //   void dispose() {
// //     _testEmailController.dispose();
// //     _testPasswordController.dispose();
// //     super.dispose();
// //   }
// // }
//
//
//
//
// // import 'package:flutter/material.dart';
// // import '../services/supabase_service.dart';
//
// // class DebugScreen extends StatefulWidget {
// //   const DebugScreen({super.key});
//
// //   @override
// //   State<DebugScreen> createState() => _DebugScreenState();
// // }
//
// // class _DebugScreenState extends State<DebugScreen> {
// //   final _testEmailController = TextEditingController();
// //   final _testPasswordController = TextEditingController();
// //   bool _isLoading = false;
// //   String _debugInfo = '';
//
// //   @override
// //   void initState() {
// //     super.initState();
// //     _checkSupabaseStatus();
// //   }
//
// //   void _appendLog(String msg) {
// //     setState(() {
// //       _debugInfo = '$msg\n\n$_debugInfo'; // latest logs at top
// //     });
// //   }
//
// //   void _checkSupabaseStatus() {
// //     setState(() {
// //       _debugInfo = '''
// // Debug Information:
// // - Supabase Configured: ${SupabaseService.isConfigured}
// // - User Signed In: ${SupabaseService.isSignedIn}
// // - Current User: ${SupabaseService.currentUser?.email ?? 'None'}
// // - Supabase URL: ${SupabaseService.SUPABASE_URL}
// // ''';
// //     });
// //   }
//
// //   Future<void> _testSignUp() async {
// //     setState(() => _isLoading = true);
//
// //     try {
// //       final email = _testEmailController.text.trim();
// //       final password = _testPasswordController.text.trim();
//
// //       if (email.isEmpty || password.isEmpty) {
// //         throw Exception('Please enter both email and password');
// //       }
//
// //       final response = await SupabaseService.signUp(email, password);
//
// //       _appendLog('''
// // ✅ Sign Up Success: ${response.user?.email}
// //    User ID: ${response.user?.id}
// //    Email Confirmed: ${response.user?.emailConfirmedAt != null}
// // ''');
// //     } catch (e) {
// //       _appendLog('❌ Sign Up Failed: $e');
// //     } finally {
// //       setState(() => _isLoading = false);
// //     }
// //   }
//
// //   Future<void> _testSignIn() async {
// //     setState(() => _isLoading = true);
//
// //     try {
// //       final email = _testEmailController.text.trim();
// //       final password = _testPasswordController.text.trim();
//
// //       if (email.isEmpty || password.isEmpty) {
// //         throw Exception('Please enter both email and password');
// //       }
//
// //       final response = await SupabaseService.signIn(email, password);
//
// //       _appendLog('''
// // ✅ Sign In Success: ${response.user?.email}
// //    User ID: ${response.user?.id}
// //    Email Confirmed: ${response.user?.emailConfirmedAt != null}
// // ''');
// //     } catch (e) {
// //       _appendLog('❌ Sign In Failed: $e');
// //     } finally {
// //       setState(() => _isLoading = false);
// //     }
// //   }
//
// //   Future<void> _testSignOut() async {
// //     setState(() => _isLoading = true);
//
// //     try {
// //       await SupabaseService.signOut();
// //       _appendLog('✅ Sign Out Success');
// //       _checkSupabaseStatus();
// //     } catch (e) {
// //       _appendLog('❌ Sign Out Failed: $e');
// //     } finally {
// //       setState(() => _isLoading = false);
// //     }
// //   }
//
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Debug Supabase'),
// //         backgroundColor: Theme.of(context).colorScheme.primary,
// //         foregroundColor: Theme.of(context).colorScheme.onPrimary,
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           children: [
// //             // Debug Info
// //             Container(
// //               height: 180,
// //               padding: const EdgeInsets.all(12),
// //               decoration: BoxDecoration(
// //                 color: Colors.grey[100],
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //               child: SingleChildScrollView(
// //                 child: Text(
// //                   _debugInfo,
// //                   style: const TextStyle(
// //                     fontFamily: 'monospace',
// //                     fontSize: 12,
// //                   ),
// //                 ),
// //               ),
// //             ),
//
// //             const SizedBox(height: 20),
//
// //             // Test Email
// //             TextField(
// //               controller: _testEmailController,
// //               decoration: const InputDecoration(
// //                 labelText: 'Test Email',
// //                 border: OutlineInputBorder(),
// //                 hintText: 'test@example.com',
// //               ),
// //               keyboardType: TextInputType.emailAddress,
// //             ),
//
// //             const SizedBox(height: 12),
//
// //             // Test Password
// //             TextField(
// //               controller: _testPasswordController,
// //               decoration: const InputDecoration(
// //                 labelText: 'Test Password',
// //                 border: OutlineInputBorder(),
// //                 hintText: 'password123',
// //               ),
// //               obscureText: true,
// //             ),
//
// //             const SizedBox(height: 20),
//
// //             // Action Buttons
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: ElevatedButton(
// //                     onPressed: _isLoading ? null : _testSignUp,
// //                     child: const Text('Test Sign Up'),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 12),
// //                 Expanded(
// //                   child: ElevatedButton(
// //                     onPressed: _isLoading ? null : _testSignIn,
// //                     child: const Text('Test Sign In'),
// //                   ),
// //                 ),
// //               ],
// //             ),
//
// //             const SizedBox(height: 12),
//
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: ElevatedButton(
// //                     onPressed: _isLoading ? null : _testSignOut,
// //                     child: const Text('Test Sign Out'),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 12),
// //                 Expanded(
// //                   child: ElevatedButton(
// //                     onPressed: () {
// //                       setState(() => _debugInfo = '');
// //                       _checkSupabaseStatus();
// //                     },
// //                     child: const Text('Refresh'),
// //                   ),
// //                 ),
// //               ],
// //             ),
//
// //             const SizedBox(height: 12),
//
// //             // Quick Setup Button
// //             ElevatedButton(
// //               onPressed: _isLoading
// //                   ? null
// //                   : () {
// //                       setState(() {
// //                         _testEmailController.text = 'palashtp21@gmail.com';
// //                         _testPasswordController.text = 'password123';
// //                         _appendLog('📝 Test credentials filled:\nEmail: palashtp21@gmail.com\nPassword: password123');
// //                       });
// //                     },
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: Colors.blue,
// //                 foregroundColor: Colors.white,
// //               ),
// //               child: const Text('Fill Test Credentials'),
// //             ),
//
// //             const SizedBox(height: 8),
//
// //             // Quick Fix Button
// //             ElevatedButton(
// //               onPressed: () {
// //                 _appendLog('''
// // 🔧 QUICK FIX INSTRUCTIONS:
//
// // 1. Go to Supabase Dashboard:
// //    https://supabase.com/dashboard
//
// // 2. Select your project ID: fviknrqqekcgqwzmksrq
//
// // 3. Go to Authentication → Settings → General
//
// // 4. Turn OFF "Enable email confirmations"
//
// // 5. Click Save
//
// // 6. Try login again!
//
// // Alternative:
// // - Fill Test Credentials
// // - Test Sign Up
// // - Then Test Sign In
// // ''');
// //               },
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: Colors.orange,
// //                 foregroundColor: Colors.white,
// //               ),
// //               child: const Text('🔧 Show Quick Fix Guide'),
// //             ),
//
// //             if (_isLoading)
// //               const Padding(
// //                 padding: EdgeInsets.all(20.0),
// //                 child: Center(child: CircularProgressIndicator()),
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
//
// //   @override
// //   void dispose() {
// //     _testEmailController.dispose();
// //     _testPasswordController.dispose();
// //     super.dispose();
// //   }
// // }
//
//
//
//
//
//  import 'package:flutter/material.dart';
// import '../services/supabase_service.dart';
//
// class DebugScreen extends StatefulWidget {
//   const DebugScreen({super.key});
//
//   @override
//   State<DebugScreen> createState() => _DebugScreenState();
// }
//
// class _DebugScreenState extends State<DebugScreen> {
//   final _testEmailController = TextEditingController();
//   final _testPasswordController = TextEditingController();
//   bool _isLoading = false;
//   String _debugInfo = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _checkSupabaseStatus();
//   }
//
//   void _appendLog(String msg) {
//     setState(() {
//       _debugInfo = '$msg\n\n$_debugInfo'; // latest logs on top
//     });
//   }
//
//   void _checkSupabaseStatus() {
//     setState(() {
//       _debugInfo = '''
// Debug Information:
// - Supabase Client: ${SupabaseService.client != null}
// - User Signed In: ${SupabaseService.isSignedIn}
// - Current User: ${SupabaseService.currentUser?.email ?? 'None'}
// - Supabase URL: ${SupabaseService.SUPABASE_URL}
// ''';
//     });
//   }
//
//   Future<void> _testSignUp() async {
//     setState(() => _isLoading = true);
//
//     try {
//       final email = _testEmailController.text.trim();
//       final password = _testPasswordController.text.trim();
//       if (email.isEmpty || password.isEmpty) {
//         throw Exception('Enter both email and password');
//       }
//
//       final response = await SupabaseService.signUp(email, password);
//       _appendLog('''
// ✅ Sign Up Success:
// Email: ${response.user?.email}
// User ID: ${response.user?.id}
// Confirmed: ${response.user?.emailConfirmedAt != null}
// ''');
//     } catch (e) {
//       _appendLog('❌ Sign Up Failed: $e');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> _testSignIn() async {
//     setState(() => _isLoading = true);
//
//     try {
//       final email = _testEmailController.text.trim();
//       final password = _testPasswordController.text.trim();
//       if (email.isEmpty || password.isEmpty) {
//         throw Exception('Enter both email and password');
//       }
//
//       final response = await SupabaseService.signIn(email, password);
//       _appendLog('''
// ✅ Sign In Success:
// Email: ${response.user?.email}
// User ID: ${response.user?.id}
// Confirmed: ${response.user?.emailConfirmedAt != null}
// ''');
//     } catch (e) {
//       _appendLog('❌ Sign In Failed: $e');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> _testSignOut() async {
//     setState(() => _isLoading = true);
//     try {
//       await SupabaseService.signOut();
//       _appendLog('✅ Sign Out Success');
//       _checkSupabaseStatus();
//     } catch (e) {
//       _appendLog('❌ Sign Out Failed: $e');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Debug Supabase'),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         foregroundColor: Theme.of(context).colorScheme.onPrimary,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Debug Info
//             Container(
//               height: 180,
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: SingleChildScrollView(
//                 child: Text(
//                   _debugInfo,
//                   style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Email + Password
//             TextField(
//               controller: _testEmailController,
//               decoration: const InputDecoration(
//                 labelText: 'Test Email',
//                 border: OutlineInputBorder(),
//                 hintText: 'test@example.com',
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _testPasswordController,
//               decoration: const InputDecoration(
//                 labelText: 'Test Password',
//                 border: OutlineInputBorder(),
//               ),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//
//             // Action Buttons
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: _isLoading ? null : _testSignUp,
//                     child: const Text('Test Sign Up'),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: _isLoading ? null : _testSignIn,
//                     child: const Text('Test Sign In'),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: _isLoading ? null : _testSignOut,
//                     child: const Text('Test Sign Out'),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       setState(() => _debugInfo = '');
//                       _checkSupabaseStatus();
//                     },
//                     child: const Text('Refresh'),
//                   ),
//                 ),
//               ],
//             ),
//
//             if (_isLoading)
//               const Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: Center(child: CircularProgressIndicator()),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _testEmailController.dispose();
//     _testPasswordController.dispose();
//     super.dispose();
//   }
// }