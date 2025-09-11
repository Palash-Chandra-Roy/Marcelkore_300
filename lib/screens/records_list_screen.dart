import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/core/utils/fetch_function.dart';
import 'package:my_app/features/record/logic/record_form_controller.dart';
import 'package:my_app/features/record/screen/record_form_screen.dart';
import 'package:my_app/models/record_data.dart';
import 'package:my_app/screens/record_details_screen.dart';
import 'package:my_app/widgets/global_snackbar.dart';

enum RecordStatus { active, pending, archived }

class RecordsListScreen extends ConsumerStatefulWidget {
  const RecordsListScreen({super.key});

  @override
  ConsumerState<RecordsListScreen> createState() => _RecordsListScreenState();
}

class _RecordsListScreenState extends ConsumerState<RecordsListScreen> {
  RecordStatus? selectedFilter; // null = All
  String searchQuery = ""; // 🔹 search query state

  @override
  Widget build(BuildContext context) {
    final asyncRecords = ref.watch(recordsStreamProvider);

    return Column(
      children: [
        _buildSearchAndFilter(context),
        Expanded(
          child: asyncRecords.when(
            data: (records) {
              // 🔹 Step 1: Filter by status
              var filtered = selectedFilter == null
                  ? records
                  : records
                        .where(
                          (r) =>
                              r.status.toLowerCase() ==
                              selectedFilter.toString().split('.').last,
                        )
                        .toList();

              // 🔹 Step 2: Filter by search query (title)
              if (searchQuery.isNotEmpty) {
                filtered = filtered
                    .where(
                      (r) => r.title.toLowerCase().contains(
                        searchQuery.toLowerCase(),
                      ),
                    )
                    .toList();
              }

              if (filtered.isEmpty) return _buildEmptyState();

              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final record = filtered[index];
                  return _buildRecordCard(record, context);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) =>
                Center(child: Text("Error loading records: $err")),
          ),
        ),
      ],
    );
  }

  // 🔹 Search & Filter Section
  Widget _buildSearchAndFilter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        children: [
          // Search box
          TextFormField(
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade500),
              ),
              hintText: 'Search by title...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          searchQuery = "";
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          SizedBox(height: 12.h),
          // Filter buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterButton("All", null),
                SizedBox(width: 8.w),
                _buildFilterButton("Active", RecordStatus.active),
                SizedBox(width: 8.w),
                _buildFilterButton("Pending", RecordStatus.pending),
                SizedBox(width: 8.w),
                _buildFilterButton("Archived", RecordStatus.archived),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Record Card (using RecordData)
  Widget _buildRecordCard(RecordData record, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: () {context.push(RecordDetailsScreen.routeName,extra: record.id);},
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.title,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(fontSize: 16.sp),
                        ),
                        SizedBox(height: 4.h),
                        _buildStatusChip(record.status),
                      ],
                    ),
                  ),
                  // Value + Actions
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "\$${record.value.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 15.sp,
                            ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, size: 18.sp),
                            onPressed: () {  context.push(RecordFormScreen.routeName,
                            extra: record.id);},
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, size: 18.sp),
                            onPressed: () {
                              showDeleteDialog(context, record.id,ref);
                              },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              // Details
              Text(
                record.details,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 13.sp),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.h),
              // Updated Time
              Text(
                "Updated ${record.updatedAgo}",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text('No records found', style: TextStyle(fontSize: 14.sp)),
          ],
        ),
      ),
    );
  }

  // 🔹 Filter Button
  Widget _buildFilterButton(String label, RecordStatus? status) {
    final isSelected = selectedFilter == status;

    return SizedBox(
      height: 32.h,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedFilter = status; // update filter state
          });
        },
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
        child: Text(label, style: TextStyle(fontSize: 13.sp)),
      ),
    );
  }

  // 🔹 Status Chip
  Widget _buildStatusChip(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: TextStyle(
          color: color,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Helpers
  static Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'archived':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }
}

Future<void> showDeleteDialog(BuildContext context, String recordId, ref) async {
  return showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this record?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // ❌ Cancel
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(ctx).pop(); // ডায়ালগ বন্ধ
              await deleteRecord(recordId); // 
             GlobalSnackBar.show(context, title: "Delete", message: "Record deleted successfully",type: CustomSnackType.success) ;
              await ref.invalidate(recordsStreamProvider);
             },
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );
}