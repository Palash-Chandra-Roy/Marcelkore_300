import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/core/utils/fetch_function.dart';
import 'package:my_app/features/auth/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/controller/dark_mode.dart';

// এখানে recordsStreamProvider আছে

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  static const routeName = "/settingsScreen";

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool darkModeEnabled = false;
  bool notificationsEnabled = true;

  void toggleDarkMode(bool value) {
    setState(() => darkModeEnabled = value);
  }

  void toggleNotifications(bool value) {
    setState(() => notificationsEnabled = value);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => LogoutDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recordsAsync = ref.watch(recordsStreamProvider);

    return Scaffold(
      body: recordsAsync.when(
        data: (records) {
          if (records.isEmpty) {
            return const Center(child: Text("No records found"));
          }

          final latest = records.first; // শুধু ১টা record show করলাম demo হিসেবে

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person,
                              size: 32, color: Colors.blue),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(latest.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium),
                              Text(latest.details,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium),
                              Text("Updated ${latest.updatedAgo}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Dark Mode
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.dark_mode_outlined),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Dark Mode"),
                              Text("Toggle theme appearance",
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                        Switch(
                          value: ref.watch(themeControllerProvider),
                          onChanged: (value) {
                            ref.read(themeControllerProvider.notifier).toggleTheme();
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                
                const SizedBox(height: 8),

                // Notifications
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_outlined),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Notifications"),
                              Text("Receive app notifications",
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                        Switch(
                          value: notificationsEnabled,
                          onChanged: toggleNotifications,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // About
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("About",
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        SizedBox(height: 12),
                        _AboutRow(label: "Version", value: "1.0.0"),
                        _AboutRow(label: "Build", value: "2024.12.30"),
                        _AboutRow(label: "Backend", value: "Supabase"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => _showLogoutDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      Theme.of(context).colorScheme.error,
                      foregroundColor:
                      Theme.of(context).colorScheme.onError,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, size: 20),
                        SizedBox(width: 8),
                        Text("Log Out"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  final String label;
  final String value;
  const _AboutRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.6))),
          Text(value,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface,
              )),
        ],
      ),
    );
  }
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        "Confirm Logout",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text("Are you sure you want to logout?"),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            await signOut(context);
          },
          child: const Text("Logout"),
        ),
      ],
    );
  }

  Future<void> signOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (context.mounted) {
      context.go(LoginScreen.routeName);
    }
  }
}