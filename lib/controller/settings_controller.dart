import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class SettingsState {
  final bool darkModeEnabled;
  final bool notificationsEnabled;
  final String userName;
  final String userEmail;
  final String memberSince;

  const SettingsState({
    this.darkModeEnabled = false,
    this.notificationsEnabled = true,
    this.userName = "User",
    this.userEmail = "No email",
    this.memberSince = "Unknown",
  });

  SettingsState copyWith({
    bool? darkModeEnabled,
    bool? notificationsEnabled,
    String? userName,
    String? userEmail,
    String? memberSince,
  }) {
    return SettingsState(
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      memberSince: memberSince ?? this.memberSince,
    );
  }
}

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController() : super(const SettingsState()) {
    _loadUserData();
  }

  /// Load user info from Supabase
  void _loadUserData() {
    final user = supabase.auth.currentUser;

    if (user != null) {
      final createdAt = user.createdAt;
      String memberSince = "Unknown";

      if (createdAt != null) {
        final parsed = DateTime.tryParse(createdAt);
        if (parsed != null) {
          memberSince = "${parsed.month}/${parsed.year}";
        }
      }

      state = state.copyWith(
        userName: user.userMetadata?["name"] ?? "User",
        userEmail: user.email ?? "No email",
        memberSince: memberSince,
      );
    }
  }

  /// ✅ Toggle Dark Mode / Light Mode
  void toggleDarkMode(bool value) {
    state = state.copyWith(darkModeEnabled: value);
    // চাইলে local storage এ save করতে পারেন
  }

  /// ✅ Toggle Notifications
  void toggleNotifications(bool value) {
    state = state.copyWith(notificationsEnabled: value);
    // চাইলে local storage এ save করতে পারেন
  }

  /// ✅ Logout with Supabase + Redirect
  Future<void> signOut(context) async {
    await supabase.auth.signOut();

  }
}

/// Riverpod Provider
final settingsProvider =
StateNotifierProvider<SettingsController, SettingsState>(
      (ref) => SettingsController(),
);