// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../services/supabase_service.dart';
// import '../models/record.dart';
// import '../utils/snackbar_utils.dart';
//
// class AuthController extends GetxController {
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     serverClientId: 'YOUR_GOOGLE_OAUTH_CLIENT_ID',
//   );
//
//   // Observables
//   var currentUser = Rxn<User>();
//   var isLoading = false.obs;
//
//   SupabaseClient get client => SupabaseService.client;
//
//   @override
//   void onInit() {
//     super.onInit();
//     currentUser.value = client.auth.currentUser;
//     client.auth.onAuthStateChange.listen((event) {
//       currentUser.value = event.session?.user;
//     });
//   }
//
//   bool get isSignedIn => currentUser.value != null;
//
//   // ----------------------
//   // AUTH METHODS
//   // ----------------------
//
//   Future<void> signUp(String email, String password, {String? name}) async {
//     isLoading.value = true;
//     try {
//       final response = await client.auth.signUp(
//         email: email,
//         password: password,
//         data: name != null ? {'name': name} : null,
//       );
//       if (response.user == null) throw Exception("SignUp failed");
//       SnackBarUtils.showSuccess(Get.context!, "Account created, please login.");
//     } catch (e) {
//       SnackBarUtils.showError(Get.context!, "SignUp failed: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> signIn(String email, String password) async {
//     isLoading.value = true;
//     try {
//       final response = await client.auth.signInWithPassword(
//         email: email,
//         password: password,
//       );
//       if (response.user == null) throw Exception("Invalid credentials");
//       SnackBarUtils.showSuccess(Get.context!, "Login successful");
//     } catch (e) {
//       SnackBarUtils.showError(Get.context!, "Login failed: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> signOut() async {
//     try {
//       await client.auth.signOut();
//       if (_googleSignIn.currentUser != null) {
//         await _googleSignIn.signOut();
//       }
//       currentUser.value = null;
//     } catch (e) {
//       SnackBarUtils.showError(Get.context!, "Logout failed: $e");
//     }
//   }
//
//   Future<void> resetPassword(String email) async {
//     try {
//       await client.auth.resetPasswordForEmail(email);
//       SnackBarUtils.showSuccess(Get.context!, "Password reset link sent");
//     } catch (e) {
//       SnackBarUtils.showError(Get.context!, "Reset failed: $e");
//     }
//   }
//
//   Future<void> signInWithGoogle() async {
//     isLoading.value = true;
//     try {
//       final googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) throw Exception('Google sign-in cancelled');
//
//       final googleAuth = await googleUser.authentication;
//       if (googleAuth.idToken == null) throw Exception('No Google ID token');
//
//       final response = await client.auth.signInWithIdToken(
//         provider: OAuthProvider.google,
//         idToken: googleAuth.idToken!,
//         accessToken: googleAuth.accessToken,
//       );
//
//       if (response.user == null) throw Exception("Google login failed");
//     } catch (e) {
//       SnackBarUtils.showError(Get.context!, "Google login failed: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ----------------------
//   // RECORD CRUD METHODS
//   // ----------------------
//
//   Future<Record?> createRecord(Record record) async {
//     try {
//       final data = await client
//           .from('records')
//           .insert({
//             'title': record.title,
//             'details': record.details,
//             'status': record.status.toString().split('.').last,
//             'value': record.value,
//             'user_id': currentUser.value!.id,
//           })
//           .select()
//           .single();
//
//       return Record.fromJson(data);
//     } catch (e) {
//       SnackBarUtils.showError(Get.context!, "Create failed: $e");
//       return null;
//     }
//   }
//
//   Future<Record?> updateRecord(Record record) async {
//     try {
//       final data = await client
//           .from('records')
//           .update({
//             'title': record.title,
//             'details': record.details,
//             'status': record.status.toString().split('.').last,
//             'value': record.value,
//             'updated_at': DateTime.now().toIso8601String(),
//           })
//           .eq('id', record.id)
//           .eq('user_id', currentUser.value!.id)
//           .select()
//           .single();
//
//       return Record.fromJson(data);
//     } catch (e) {
//       SnackBarUtils.showError(Get.context!, "Update failed: $e");
//       return null;
//     }
//   }
//
//   Future<List<Record>> getRecords() async {
//     try {
//       final data = await client
//           .from('records')
//           .select()
//           .eq('user_id', currentUser.value!.id)
//           .order('updated_at', ascending: false);
//
//       return data.map<Record>((json) => Record.fromJson(json)).toList();
//     } catch (e) {
//       SnackBarUtils.showError(Get.context!, "Fetch failed: $e");
//       return [];
//     }
//   }
//
//   Future<void> deleteRecord(String id) async {
//     try {
//       await client.from('records').delete().eq('id', id).eq('user_id', currentUser.value!.id);
//       SnackBarUtils.showSuccess(Get.context!, "Record deleted");
//     } catch (e) {
//       SnackBarUtils.showError(Get.context!, "Delete failed: $e");
//     }
//   }
// }