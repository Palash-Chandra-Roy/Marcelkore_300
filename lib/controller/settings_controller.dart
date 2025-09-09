import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/supabase_service.dart';

class SettingsState {
  final bool darkModeEnabled;
  final bool notificationsEnabled;

  const SettingsState({
    this.darkModeEnabled = false,
    this.notificationsEnabled = true,
  });

  SettingsState copyWith({
    bool? darkModeEnabled,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

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
}

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController() : super(const SettingsState());

  void toggleDarkMode(bool value) {
    state = state.copyWith(darkModeEnabled: value);
    // TODO: save preference (local storage / supabase user metadata)
  }

  void toggleNotifications(bool value) {
    state = state.copyWith(notificationsEnabled: value);
    // TODO: save preference (local storage / supabase user metadata)
  }

  Future<void> logout(WidgetRef ref) async {
    await SupabaseService.signOut();
    // এখানে snackbar আর navigation riverpod context থেকে করতে হবে
  }
}

final settingsProvider =
StateNotifierProvider<SettingsController, SettingsState>(
      (ref) => SettingsController(),
);