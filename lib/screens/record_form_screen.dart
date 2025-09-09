// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../models/record.dart';
// import '../services/supabase_service.dart';

// class RecordFormScreen extends StatefulWidget {
//   final Record? record;
//   final Function(Record) onSave;
//   final VoidCallback onCancel;

//   const RecordFormScreen({
//     super.key,
//     this.record,
//     required this.onSave,
//     required this.onCancel,
//   });

//   @override
//   State<RecordFormScreen> createState() => _RecordFormScreenState();
// }

// class _RecordFormScreenState extends State<RecordFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _detailsController = TextEditingController();
//   final _valueController = TextEditingController();
  
//   RecordStatus _selectedStatus = RecordStatus.active;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.record != null) {
//       _titleController.text = widget.record!.title;
//       _detailsController.text = widget.record!.details;
//       _valueController.text = widget.record!.value.toString();
//       _selectedStatus = widget.record!.status;
//     }
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _detailsController.dispose();
//     _valueController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleSave() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);
    
//     try {
//       final record = Record(
//         id: widget.record?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
//         title: _titleController.text.trim(),
//         details: _detailsController.text.trim(),
//         status: _selectedStatus,
//         value: double.parse(_valueController.text),
//         updatedAt: DateTime.now(),
//       );

//       final savedRecord = widget.record != null
//           ? await SupabaseService.updateRecord(record)
//           : await SupabaseService.createRecord(record);

//       setState(() => _isLoading = false);
//       widget.onSave(savedRecord);
//     } catch (e) {
//       setState(() => _isLoading = false);
      
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to save record: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isEditing = widget.record != null;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(isEditing ? 'Edit Record' : 'Create Record'),
//         leading: IconButton(
//           icon: const Icon(Icons.close),
//           onPressed: widget.onCancel,
//         ),
//         actions: [
//           TextButton(
//             onPressed: _isLoading ? null : _handleSave,
//             child: _isLoading
//                 ? const SizedBox(
//                     width: 16,
//                     height: 16,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   )
//                 : const Text('Save'),
//           ),
//         ],
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Title Field
//               Text(
//                 'Title',
//                 style: Theme.of(context).textTheme.labelLarge,
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(
//                   hintText: 'Enter record title',
//                   prefixIcon: Icon(Icons.title),
//                 ),
//                 textInputAction: TextInputAction.next,
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   if (value.trim().length < 3) {
//                     return 'Title must be at least 3 characters';
//                   }
//                   return null;
//                 },
//               ),

//               const SizedBox(height: 24),

//               // Details Field
//               Text(
//                 'Details',
//                 style: Theme.of(context).textTheme.labelLarge,
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _detailsController,
//                 decoration: const InputDecoration(
//                   hintText: 'Enter record details',
//                   prefixIcon: Icon(Icons.description),
//                   alignLabelWithHint: true,
//                 ),
//                 maxLines: 4,
//                 textInputAction: TextInputAction.next,
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return 'Please enter details';
//                   }
//                   if (value.trim().length < 10) {
//                     return 'Details must be at least 10 characters';
//                   }
//                   return null;
//                 },
//               ),

//               const SizedBox(height: 24),

//               // Status Field
//               Text(
//                 'Status',
//                 style: Theme.of(context).textTheme.labelLarge,
//               ),
//               const SizedBox(height: 8),
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).inputDecorationTheme.fillColor,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<RecordStatus>(
//                     value: _selectedStatus,
//                     isExpanded: true,
//                     onChanged: (RecordStatus? newValue) {
//                       if (newValue != null) {
//                         setState(() => _selectedStatus = newValue);
//                       }
//                     },
//                     items: RecordStatus.values.map<DropdownMenuItem<RecordStatus>>((RecordStatus value) {
//                       return DropdownMenuItem<RecordStatus>(
//                         value: value,
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 12,
//                               height: 12,
//                               decoration: BoxDecoration(
//                                 color: _getStatusColor(value),
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Text(_getStatusString(value)),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // Value Field
//               Text(
//                 'Value',
//                 style: Theme.of(context).textTheme.labelLarge,
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _valueController,
//                 decoration: const InputDecoration(
//                   hintText: '0.00',
//                   prefixIcon: Icon(Icons.attach_money),
//                 ),
//                 keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                 textInputAction: TextInputAction.done,
//                 inputFormatters: [
//                   FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
//                 ],
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return 'Please enter a value';
//                   }
//                   final double? parsedValue = double.tryParse(value);
//                   if (parsedValue == null) {
//                     return 'Please enter a valid number';
//                   }
//                   if (parsedValue < 0) {
//                     return 'Value cannot be negative';
//                   }
//                   return null;
//                 },
//               ),

//               const SizedBox(height: 32),

//               // Action Buttons
//               SizedBox(
//                 width: double.infinity,
//                 height: 48,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _handleSave,
//                   child: _isLoading
//                       ? const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                               ),
//                             ),
//                             SizedBox(width: 12),
//                             Text('Saving...'),
//                           ],
//                         )
//                       : Text(isEditing ? 'Update Record' : 'Create Record'),
//                 ),
//               ),

//               const SizedBox(height: 12),

//               SizedBox(
//                 width: double.infinity,
//                 height: 48,
//                 child: OutlinedButton(
//                   onPressed: widget.onCancel,
//                   child: const Text('Cancel'),
//                 ),
//               ),

//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
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

//   String _getStatusString(RecordStatus status) {
//     switch (status) {
//       case RecordStatus.active:
//         return 'Active';
//       case RecordStatus.pending:
//         return 'Pending';
//       case RecordStatus.archived:
//         return 'Archived';
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controller/record_form_controller.dart';
import '../models/record.dart';

class RecordFormScreen extends StatelessWidget {
  final Record? record;
  final Function(Record) onSave;
  final VoidCallback onCancel;

  const RecordFormScreen({
    super.key,
    this.record,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecordFormController());
    controller.setRecord(record);

    final isEditing = record != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Record' : 'Create Record'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onCancel,
        ),
        actions: [
          Obx(() => TextButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                        final saved = await controller.saveRecord();
                        if (saved != null) {
                          onSave(saved);
                        }
                      },
                child: controller.isLoading.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              )),
        ],
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text('Title', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter record title',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Please enter a title'
                        : (value.trim().length < 3
                            ? 'Title must be at least 3 characters'
                            : null),
              ),
              const SizedBox(height: 24),

              // Details
              Text('Details', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.detailsController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Enter record details',
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Please enter details'
                        : (value.trim().length < 10
                            ? 'Details must be at least 10 characters'
                            : null),
              ),
              const SizedBox(height: 24),

              // Status
              Text('Status', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Obx(() => DropdownButtonFormField<RecordStatus>(
                    value: controller.selectedStatus.value,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        controller.selectedStatus.value = newValue;
                      }
                    },
                    items: RecordStatus.values
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status.toString().split('.').last),
                            ))
                        .toList(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.flag),
                    ),
                  )),
              const SizedBox(height: 24),

              // Value
              Text('Value', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.valueController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: '0.00',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  final parsed = double.tryParse(value ?? "");
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a value';
                  }
                  if (parsed == null) return 'Enter a valid number';
                  if (parsed < 0) return 'Value cannot be negative';
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Buttons
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                              final saved = await controller.saveRecord();
                              if (saved != null) {
                                onSave(saved);
                              }
                            },
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(isEditing
                              ? 'Update Record'
                              : 'Create Record'),
                    ),
                  )),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: onCancel,
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
