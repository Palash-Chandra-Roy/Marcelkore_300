import 'package:get/get.dart';
import '../services/supabase_service.dart';

class SettingsController extends GetxController {
  var darkModeEnabled = false.obs;
  var notificationsEnabled = true.obs;

  String get userName =>
      SupabaseService.currentUser?.userMetadata?['name'] ?? 'User';

  String get userEmail =>
      SupabaseService.currentUser?.email ?? 'No email';

  String get memberSince {
    final createdAt = SupabaseService.currentUser?.createdAt;
    if (createdAt == null) return 'Unknown';
    final date = DateTime.tryParse(createdAt);
    return date != null ? "${date.month}/${date.year}" : 'Unknown';
  }

  void toggleDarkMode(bool value) {
    darkModeEnabled.value = value;
    // TODO: save preference (local storage / supabase user metadata)
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    // TODO: save preference (local storage / supabase user metadata)
  }

  void logout() async {
    await SupabaseService.signOut();
    Get.snackbar("Logout", "You have been logged out.");
    // navigate back to login
    Get.offAllNamed("/login");
  }
}
