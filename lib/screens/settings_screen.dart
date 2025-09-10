import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/features/auth/screen/login_screen.dart';
import '../controller/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const routeName = "/settingsScreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);

    return Scaffold(
      body: SingleChildScrollView(
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
                        color: Theme
                            .of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 32,
                        color: Colors.blue,

                        // Theme
                        //     .of(context)
                        //     .colorScheme
                        //     .secondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(state.userName,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium),
                          Text(state.userEmail,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium),
                          Text("Member since ${state.memberSince}",
                              style: Theme
                                  .of(context)
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
                        children:  [
                          Text("Dark Mode"),
                          Text("Toggle theme appearance",
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    Switch(
                      value: state.darkModeEnabled,
                      onChanged: controller.toggleDarkMode,
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
                      value: state.notificationsEnabled,
                      onChanged: controller.toggleNotifications,
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
                    Text(
                        "About", style: TextStyle(fontWeight: FontWeight.w500)),
                    SizedBox(height: 12),
                    _AboutRow(label: "Version", value: "1.0.0"),
                    _AboutRow(label: "Build", value: "2024.12.30"),
                    _AboutRow(label: "Backend", value: "Supabase"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Logout Button


            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: const Text("Confirm Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          // ❌ Cancel Button
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            // শুধু popup বন্ধ করবে
                            child: const Text("Cancel"),
                          ),

                          // ✅ Logout Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              Navigator.pop(context); // dialog close
                              await controller.signOut(
                                  context); // Supabase থেকে logout

                              if (context.mounted) {
                                // context.push এর বদলে go ব্যবহার করুন
                                context.go(LoginScreen.routeName);
                              }
                            },
                            child: const Text("Logout"),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme
                      .of(context)
                      .colorScheme
                      .error,
                  foregroundColor: Theme
                      .of(context)
                      .colorScheme
                      .onError,
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
            )


          ],
        ),
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
                  color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }
}