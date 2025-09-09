import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controller/record_details_controller.dart';
import 'package:my_app/models/record.dart';

class RecordDetailsScreen extends StatelessWidget {
  const RecordDetailsScreen({super.key, required Record record, required void Function() onBack, required void Function(Record record) onEdit, required void Function(String id) onDelete});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecordDetailsController());

    return Obx(() {
      final record = controller.record.value;
      if (record == null) {
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
                  _showDeleteDialog(context, controller);
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
                      Text(record.title,
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 12),
                      Text(record.details,
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 12),
                      Text("Value: \$${record.value.toStringAsFixed(2)}"),
                      Text("Updated: ${record.updatedAt}"),
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
                onPressed: () => _showDeleteDialog(context, controller),
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
    });
  }

  void _showDeleteDialog(
      BuildContext context, RecordDetailsController controller) {
    final record = controller.record.value;
    if (record == null) return;

    Get.dialog(
      AlertDialog(
        title: const Text('Delete Record'),
        content: Text('Are you sure you want to delete "${record.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
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
