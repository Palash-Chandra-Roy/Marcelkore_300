// import 'package:flutter/material.dart';
// import '../models/record.dart';
// import '../services/supabase_service.dart';

// class RecordsListScreen extends StatefulWidget {
//   final Function(Record) onEditRecord;
//   final Function(String) onDeleteRecord;
//   final Function(Record) onViewRecord;

//   const RecordsListScreen({
//     super.key,
//     required this.onEditRecord,
//     required this.onDeleteRecord,
//     required this.onViewRecord,
//   });

//   @override
//   State<RecordsListScreen> createState() => _RecordsListScreenState();
// }

// class _RecordsListScreenState extends State<RecordsListScreen> {
//   List<Record> _records = [];
//   String _searchQuery = '';
//   RecordStatus? _statusFilter;
//   bool _isLoading = true;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _loadRecords();
//   }

//   Future<void> _loadRecords() async {
//     try {
//       setState(() {
//         _isLoading = true;
//         _error = null;
//       });
      
//       final records = await SupabaseService.getRecords(
//         search: _searchQuery.isNotEmpty ? _searchQuery : null,
//         status: _statusFilter,
//       );
      
//       setState(() {
//         _records = records;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   List<Record> get _filteredRecords {
//     return _records.where((record) {
//       final matchesSearch = record.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//                            record.details.toLowerCase().contains(_searchQuery.toLowerCase());
//       final matchesStatus = _statusFilter == null || record.status == _statusFilter;
//       return matchesSearch && matchesStatus;
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     if (_error != null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 64, color: Colors.red),
//             const SizedBox(height: 16),
//             Text('Error loading records'),
//             const SizedBox(height: 8),
//             Text(
//               _error!,
//               style: Theme.of(context).textTheme.bodySmall,
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _loadRecords,
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }

//     final filteredRecords = _filteredRecords;

//     return Column(
//       children: [
//         // Search and Filter Section
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Theme.of(context).cardColor,
//             border: Border(
//               bottom: BorderSide(color: Theme.of(context).dividerColor),
//             ),
//           ),
//           child: Column(
//             children: [
//               // Search Bar
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Search records...',
//                   prefixIcon: const Icon(Icons.search),
//                   suffixIcon: _searchQuery.isNotEmpty
//                       ? IconButton(
//                           icon: const Icon(Icons.clear),
//                           onPressed: () => setState(() => _searchQuery = ''),
//                         )
//                       : null,
//                 ),
//                 onChanged: (value) {
//                   setState(() => _searchQuery = value);
//                   _loadRecords(); // Reload data when search changes
//                 },
//               ),
              
//               const SizedBox(height: 12),
              
//               // Filter Buttons
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     _buildFilterButton('All', _statusFilter == null),
//                     const SizedBox(width: 8),
//                     _buildFilterButton('Active', _statusFilter == RecordStatus.active),
//                     const SizedBox(width: 8),
//                     _buildFilterButton('Pending', _statusFilter == RecordStatus.pending),
//                     const SizedBox(width: 8),
//                     _buildFilterButton('Archived', _statusFilter == RecordStatus.archived),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // Records List
//         Expanded(
//           child: filteredRecords.isEmpty
//               ? _buildEmptyState()
//               : ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: filteredRecords.length,
//                   itemBuilder: (context, index) {
//                     final record = filteredRecords[index];
//                     return _buildRecordCard(record);
//                   },
//                 ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.inbox_outlined,
//               size: 64,
//               color: Theme.of(context).textTheme.bodySmall?.color,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               _searchQuery.isNotEmpty || _statusFilter != null
//                   ? 'No records match your filters'
//                   : 'No records yet',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               _searchQuery.isNotEmpty || _statusFilter != null
//                   ? 'Try adjusting your search or filters'
//                   : 'Create your first record to get started',
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 color: Theme.of(context).textTheme.bodySmall?.color,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRecordCard(Record record) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: InkWell(
//         onTap: () => widget.onViewRecord(record),
//         borderRadius: BorderRadius.circular(10),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header Row
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           record.title,
//                           style: Theme.of(context).textTheme.titleMedium,
//                         ),
//                         const SizedBox(height: 4),
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: _getStatusColor(record.status).withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             record.statusString,
//                             style: TextStyle(
//                               color: _getStatusColor(record.status),
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         '\${record.value.toInt().toString()}',
//                         style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.edit, size: 18),
//                             onPressed: () => widget.onEditRecord(record),
//                             constraints: const BoxConstraints(
//                               minWidth: 32,
//                               minHeight: 32,
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete, size: 18),
//                             onPressed: () => _showDeleteDialog(record),
//                             constraints: const BoxConstraints(
//                               minWidth: 32,
//                               minHeight: 32,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 8),

//               // Details
//               Text(
//                 record.details,
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   color: Theme.of(context).textTheme.bodySmall?.color,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),

//               const SizedBox(height: 8),

//               // Updated time
//               Text(
//                 'Updated ${_formatDateTime(record.updatedAt)}',
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showDeleteDialog(Record record) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Record'),
//         content: Text('Are you sure you want to delete "${record.title}"? This action cannot be undone.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.of(context).pop();
//               try {
//                 await SupabaseService.deleteRecord(record.id);
//                 setState(() {
//                   _records.removeWhere((r) => r.id == record.id);
//                 });
//                 widget.onDeleteRecord(record.id);
//               } catch (e) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Failed to delete record: $e'),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//               }
//             },
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterButton(String label, bool isSelected) {
//     return SizedBox(
//       height: 32,
//       child: ElevatedButton(
//         onPressed: () {
//           setState(() {
//             switch (label) {
//               case 'All':
//                 _statusFilter = null;
//                 break;
//               case 'Active':
//                 _statusFilter = isSelected ? null : RecordStatus.active;
//                 break;
//               case 'Pending':
//                 _statusFilter = isSelected ? null : RecordStatus.pending;
//                 break;
//               case 'Archived':
//                 _statusFilter = isSelected ? null : RecordStatus.archived;
//                 break;
//             }
//           });
//           _loadRecords(); // Reload data when filter changes
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: isSelected 
//               ? Theme.of(context).colorScheme.primary 
//               : Theme.of(context).colorScheme.surface,
//           foregroundColor: isSelected 
//               ? Theme.of(context).colorScheme.onPrimary 
//               : Theme.of(context).colorScheme.onSurface,
//           elevation: isSelected ? 2 : 0,
//           side: isSelected ? null : BorderSide(color: Theme.of(context).colorScheme.outline),
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//         ),
//         child: Text(label),
//       ),
//     );
//   }

//   Color _getStatusColor(RecordStatus status) {
//     switch (status) {
//       case RecordStatus.active:
//         return Colors.green;
//       case RecordStatus.pending:
//         return Colors.orange;
//       case RecordStatus.archived:
//         return Colors.grey;
//     }
//   }

//   String _formatDateTime(DateTime dateTime) {
//     final now = DateTime.now();
//     final difference = now.difference(dateTime);

//     if (difference.inDays > 0) {
//       return '${difference.inDays} days ago';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours} hours ago';
//     } else if (difference.inMinutes > 0) {
//       return '${difference.inMinutes} minutes ago';
//     } else {
//       return 'just now';
//     }
//   }
// }




import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controller/records_list_controller.dart';
import '../models/record.dart';

class RecordsListScreen extends StatelessWidget {
  final Function(Record) onEditRecord;
  final Function(String) onDeleteRecord;
  final Function(Record) onViewRecord;

  const RecordsListScreen({
    super.key,
    required this.onEditRecord,
    required this.onDeleteRecord,
    required this.onViewRecord,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecordsController());

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.error.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Error loading records'),
              const SizedBox(height: 8),
              Text(controller.error.value, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: controller.loadRecords, child: const Text('Retry')),
            ],
          ),
        );
      }

      final filteredRecords = controller.filteredRecords;

      return Column(
        children: [
          _buildSearchAndFilter(controller, context),
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
    });
  }

  Widget _buildSearchAndFilter(RecordsController controller, BuildContext context) {
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
              suffixIcon: controller.searchQuery.value.isNotEmpty
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
                _buildFilterButton('All', controller, null, context),
                const SizedBox(width: 8),
                _buildFilterButton('Active', controller, RecordStatus.active, context),
                const SizedBox(width: 8),
                _buildFilterButton('Pending', controller, RecordStatus.pending, context),
                const SizedBox(width: 8),
                _buildFilterButton('Archived', controller, RecordStatus.archived, context),
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
        onTap: () => onViewRecord(record),
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
                            onPressed: () => onEditRecord(record),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 18),
                            onPressed: () {
                              _showDeleteDialog(record, controller, context);
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



  void _showDeleteDialog(
    Record record, RecordsController controller, BuildContext context) {
  Get.dialog(
    AlertDialog(
      title: const Text('Delete Record'),
      content: Text('Are you sure you want to delete "${record.title}"?'),
      actions: [
        TextButton(
          onPressed: () => Get.back(), // close dialog
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Get.back(); // close dialog
            await controller.deleteRecord(record.id); // delete call
            Get.snackbar("Success", "Record deleted",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white);
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
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

  Widget _buildFilterButton(
      String label, RecordsController controller, RecordStatus? status, BuildContext context) {
    final isSelected = controller.statusFilter.value == status;
    return Obx(() => SizedBox(
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
        ));
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


