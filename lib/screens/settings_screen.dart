import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required bool Function() onLogout});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
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
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 32,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(controller.userName,
                                  style: Theme.of(context).textTheme.titleMedium),
                              Text(controller.userEmail,
                                  style: Theme.of(context).textTheme.bodyMedium),
                              Text("Member since ${controller.memberSince}",
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                          )),
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
                child: Obx(() => Row(
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
                          value: controller.darkModeEnabled.value,
                          onChanged: controller.toggleDarkMode,
                        ),
                      ],
                    )),
              ),
            ),
            const SizedBox(height: 8),

            // Notifications
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Obx(() => Row(
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
                          value: controller.notificationsEnabled.value,
                          onChanged: controller.toggleNotifications,
                        ),
                      ],
                    )),
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
                    Text("About", style: TextStyle(fontWeight: FontWeight.w500)),
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
                onPressed: controller.logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
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
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
          Text(value,
              style: TextStyle(
                  fontSize: 14, color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }
}
