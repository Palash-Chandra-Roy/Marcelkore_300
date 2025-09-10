import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/record.dart';
import '../controller/records_list_controller.dart';

class RecordsListScreen extends ConsumerWidget {


  const RecordsListScreen({
    super.key,
   
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recordsProvider);
    final controller = ref.read(recordsProvider.notifier);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Error loading records'),
            const SizedBox(height: 8),
            Text(state.error, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.loadRecords,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final filteredRecords = controller.filteredRecords;

    return Column(
      children: [
        _buildSearchAndFilter(state, controller, context),
        Expanded(
          child: filteredRecords.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
            onRefresh: controller.loadRecords,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredRecords.length,
              itemBuilder: (context, index) {
                final record = filteredRecords[index];
                return _buildRecordCard(record, controller, context);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter(
      RecordsState state, RecordsController controller, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Column(
        children: [
          // Search
          TextField(
            decoration: InputDecoration(
              hintText: 'Search records...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: state.searchQuery.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => controller.setSearch(""),
              )
                  : null,
            ),
            onChanged: controller.setSearch,
          ),
          const SizedBox(height: 12),
          // Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterButton('All', state, controller, null, context),
                const SizedBox(width: 8),
                _buildFilterButton(
                    'Active', state, controller, RecordStatus.active, context),
                const SizedBox(width: 8),
                _buildFilterButton(
                    'Pending', state, controller, RecordStatus.pending, context),
                const SizedBox(width: 8),
                _buildFilterButton('Archived', state, controller,
                    RecordStatus.archived, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard(
      Record record, RecordsController controller, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: (){},
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(record.title,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        _buildStatusChip(record.status),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${record.value.toStringAsFixed(2)}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: (){},
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 18),
                            onPressed: () async {
                              final confirm = await _showDeleteDialog(
                                  context, record.title);
                              if (confirm) {
                                await controller.deleteRecord(record.id);
                                ;
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                record.details,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text('Updated ${_formatDateTime(record.updatedAt)}',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteDialog(BuildContext context, String title) async {
    return await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Record'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ??
        false;
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No records found'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, RecordsState state,
      RecordsController controller, RecordStatus? status, BuildContext context) {
    final isSelected = state.statusFilter == status;
    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: () => controller.setStatusFilter(status),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          foregroundColor: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface,
          side: isSelected
              ? null
              : BorderSide(color: Theme.of(context).dividerColor),
          elevation: isSelected ? 2 : 0,
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildStatusChip(RecordStatus status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusString(status),
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  Color _getStatusColor(RecordStatus status) {
    switch (status) {
      case RecordStatus.active:
        return Colors.green;
      case RecordStatus.pending:
        return Colors.orange;
      case RecordStatus.archived:
        return Colors.grey;
    }
  }

  String _getStatusString(RecordStatus status) {
    switch (status) {
      case RecordStatus.active:
        return 'Active';
      case RecordStatus.pending:
        return 'Pending';
      case RecordStatus.archived:
        return 'Archived';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'just now';
  }
}