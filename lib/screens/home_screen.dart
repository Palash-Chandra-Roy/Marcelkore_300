import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/controller/home_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  static const routeName = "/homeScreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final controller = ref.read(homeProvider.notifier);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Hero Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Text(
                    'Welcome to My App',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A simple CRUD demo app with authentication',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Quick Stats (Riverpod state ব্যবহার করছে)
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Total Records',
                    state.totalRecords.toString(),
                    Icons.description,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Last Update',
                    state.lastUpdate,
                    Icons.access_time,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Main Actions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Getting Started',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This app demonstrates basic CRUD operations with user authentication. Create, view, edit, and delete records to see it in action.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                        Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed:(){ HomeController.onCreateRecord(context);},
                            child: const Text('Create Your First Record'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed:(){ HomeController.onNavigateToRecords();},
                            child: const Text('View All Records'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Feature Highlights
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'App Features',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFeatureItem(context, 'User authentication & profiles'),
                const SizedBox(height: 12),
                _buildFeatureItem(
                    context, 'Create, read, update, delete records'),
                const SizedBox(height: 12),
                _buildFeatureItem(context, 'Real-time data synchronization'),
                const SizedBox(height: 12),
                _buildFeatureItem(context, 'Responsive mobile-first design'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context,
      String title,
      String value,
      IconData icon,
      ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}