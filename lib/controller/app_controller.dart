// import 'package:get/get.dart';
// import '../models/record.dart';
// import '../services/supabase_service.dart';
//
// enum Screen { login, signup, home, records, recordForm, recordDetails, settings }
// enum AppTab { home, records, settings }
//
// class AppController extends GetxController {
//   // Auth
//   var isAuthenticated = false.obs;
//
//   // Navigation
//   var currentScreen = Screen.login.obs;
//   var currentTab = AppTab.home.obs;
//
//   // Records
//   var selectedRecord = Rxn<Record>();
//   var editingRecord = Rxn<Record>();
//
//   // Dialogs
//   var showLogoutDialog = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _checkAuthState();
//   }
//
//   void _checkAuthState() {
//     isAuthenticated.value = SupabaseService.isSignedIn;
//     if (isAuthenticated.value) {
//       currentScreen.value = Screen.home;
//     }
//   }
//
//   // -------- AUTH --------
//   void handleLogin() {
//     isAuthenticated.value = true;
//     currentScreen.value = Screen.home;
//     currentTab.value = AppTab.home;
//   }
//
//   void handleSignUp() {
//     currentScreen.value = Screen.login;
//   }
//
//   Future<void> handleLogout() async {
//     await SupabaseService.signOut();
//     isAuthenticated.value = false;
//     currentScreen.value = Screen.login;
//     currentTab.value = AppTab.home;
//     showLogoutDialog.value = false;
//   }
//
//   // -------- NAV --------
//   void changeTab(AppTab tab) {
//     currentTab.value = tab;
//     switch (tab) {
//       case AppTab.home:
//         currentScreen.value = Screen.home;
//         break;
//       case AppTab.records:
//         currentScreen.value = Screen.records;
//         break;
//       case AppTab.settings:
//         currentScreen.value = Screen.settings;
//         break;
//     }
//   }
//
//   // -------- RECORDS --------
//   void createRecord() {
//     editingRecord.value = null;
//     currentScreen.value = Screen.recordForm;
//   }
//
//   void editRecord(Record record) {
//     editingRecord.value = record;
//     currentScreen.value = Screen.recordForm;
//   }
//
//   void viewRecord(Record record) {
//     selectedRecord.value = record;
//     currentScreen.value = Screen.recordDetails;
//   }
//
//   void saveRecord(Record record) {
//     editingRecord.value = null;
//     currentScreen.value = Screen.records;
//     currentTab.value = AppTab.records;
//   }
//
//   void deleteRecord(String id) {
//     selectedRecord.value = null;
//     currentScreen.value = Screen.records;
//     currentTab.value = AppTab.records;
//   }
//
//   void cancelForm() {
//     editingRecord.value = null;
//     currentScreen.value = Screen.records;
//   }
//
//   void backToRecords() {
//     selectedRecord.value = null;
//     currentScreen.value = Screen.records;
//   }
// }