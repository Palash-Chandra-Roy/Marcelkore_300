import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/features/record/screen/record_form_screen.dart';
import 'package:my_app/models/record_data.dart';
import 'package:my_app/utils/record_form_args.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/utils/fetch_function.dart';

class RecordDetailsScreen extends ConsumerWidget {
  const RecordDetailsScreen({
    super.key,
    required this.recordId,
  });
  static const routeName = '/record-details';

  final String recordId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordAsync = ref.watch(recordDetailsByIdProvider(recordId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              recordAsync.whenData((record) {
                _showDeleteDialog(context, ref, record.id);
              });
            },
          ),
        ],
      ),
      body: recordAsync.when(
        data: (record) => _buildDetails(context, ref, record),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
      ),
    );
  }

  Widget _buildDetails(BuildContext context, WidgetRef ref, RecordData record) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title + status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  record.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: record.status == "archived"
                      ? Colors.grey.shade300
                      : record.status == "active"
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  record.status,
                  style: TextStyle(
                    fontSize: 12,
                    color: record.status == "archived"
                        ? Colors.grey
                        : record.status == "active"
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Last updated",
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),

          const SizedBox(height: 20),

          /// Details
          _sectionCard(
            context,
            title: "Details",
            child: Text(record.details,
                style: theme.textTheme.bodyMedium),
          ),

          const SizedBox(height: 16),

          /// Value
          _sectionCard(
            context,
            title: "Value",
            child: Text(
              "\$${record.value.toStringAsFixed(2)}",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// Information
          _sectionCard(
            context,
            title: "Information",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow("Record ID", record.id),
                _infoRow("Status", record.status),
                _infoRow("Created", record.createdAt.toString()),
                _infoRow("Last Modified", record.updatedAt.toString()),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// Action buttons
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
             context.push(RecordFormScreen.routeName, extra: RecordFormArgs(
               id: record.id,
               title: record.title,
               details: record.details,
               status: record.status,
               value: record.value,
             ));
            },
            child: const Text("Edit Record"),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              _showDeleteDialog(context, ref, record.id);
            },
            child: const Text("Delete Record"),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(BuildContext context,
      {required String title, required Widget child}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ",
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Record'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              await Supabase.instance.client
                  .from('records')
                  .delete()
                  .eq('id', id);

              ref.invalidate(recordsStreamProvider);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

final recordDetailsByIdProvider =
FutureProvider.family<RecordData, String>((ref, id) async {
  final response = await Supabase.instance.client
      .from('records')
      .select()
      .eq('id', id)
      .maybeSingle();

  if (response == null) {
    throw Exception("Record not found");
  }

  return RecordData.fromMap(response);
});