import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/controller/record_details_controller.dart';
import 'package:my_app/models/record.dart';

class RecordDetailsScreen extends ConsumerWidget {
  const RecordDetailsScreen({
    super.key,
    required this.record,
    required this.onBack,
    required this.onEdit,
    required this.onDelete,
  });

  final Record record;
  final VoidCallback onBack;
  final void Function(Record record) onEdit;
  final void Function(String id) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(recordDetailsProvider.notifier);

    // callbacks সেট করা
    controller.onBack = onBack;
    controller.onEdit = onEdit;
    controller.onDelete = onDelete;
    controller.setRecord(record);

    final currentRecord = ref.watch(recordDetailsProvider);

    if (currentRecord == null) {
      return const Scaffold(
        body: Center(child: Text("No record selected")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.goBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: controller.editRecord,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteDialog(context, controller, currentRecord);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currentRecord.title,
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    Text(currentRecord.details,
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 12),
                    Text("Value: \$${currentRecord.value.toStringAsFixed(2)}"),
                    Text("Updated: ${currentRecord.updatedAt}"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: controller.editRecord,
              icon: const Icon(Icons.edit),
              label: const Text("Edit"),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () =>
                  _showDeleteDialog(context, controller, currentRecord),
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context,
      RecordDetailsController controller, Record currentRecord) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Record'),
        content: Text('Are you sure you want to delete "${currentRecord.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.deleteRecord();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}