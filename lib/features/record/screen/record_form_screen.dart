import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/features/record/logic/record_form_controller.dart';
import 'package:my_app/screens/main_app.dart';
import 'package:my_app/widgets/global_snackbar.dart';

final recordFormProvider = StateProvider.family<Map<String, dynamic>, String?>(
      (ref, statusParam) {
    return {
      'status': statusParam ?? 'active', // 👈 যদি status null হয়, তাহলে "active"
    };
  },
);

class RecordFormScreen extends ConsumerWidget {
  const RecordFormScreen( {super.key, this.isId, this.title, this.value, this.details, this.status,});
  final String? isId;
  final String? title;
  final double? value;
  final String? details;
  final String? status;

  static const routeName = "/recordFormScreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isEditing = isId != null && isId!.isNotEmpty;
    final statusOptions = {
      'active': 'Active',
      'pending': 'Pending',
      'archived': 'Archived',
    };

    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text:isEditing? title:null);
    final detailsController = TextEditingController(text:isEditing? details:null);
    final valueController = TextEditingController(text:isEditing? value.toString():null);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Record' : 'Create Record'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text('Title', style: Theme.of(context).textTheme.labelLarge),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter record title',
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter a title'
                      : (value.trim().length < 3
                      ? 'Title must be at least 3 characters'
                      : null),
                ),
                SizedBox(height: 24.h),

                // Details
                Text('Details', style: Theme.of(context).textTheme.labelLarge),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: detailsController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter record details',
                    prefixIcon: Icon(Icons.description),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter details'
                      : (value.trim().length < 10
                      ? 'Details must be at least 10 characters'
                      : null),
                ),
                SizedBox(height: 24.h),

                // Status
                Text('Status', style: Theme.of(context).textTheme.labelLarge),
                SizedBox(height: 8.h),
                Consumer(
                  builder: (context, ref, _) {
                    final selectedStatus =
                    ref.watch(recordFormProvider(isEditing? status:null))['status'] as String;
                    return DropdownButtonFormField<String>(
                      value: selectedStatus,
                      onChanged: (newValue) {
                        if (newValue != null) {
                          ref
                              .read(recordFormProvider(isEditing?status:null).notifier)
                              .state['status'] = newValue;
                        }
                      },
                      items: statusOptions.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.flag),
                      ),
                    );
                  },
                ),
                SizedBox(height: 24.h),

                // Value
                Text('Value', style: Theme.of(context).textTheme.labelLarge),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: valueController,
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
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
                SizedBox(height: 32.h),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        final statuss =
                        ref.read(recordFormProvider(isEditing?status:null))['status'] as String;

                        try {
                          if (isEditing) {
                            await updateRecord(
                              recordId: isId!,
                              title: titleController.text,
                              details: detailsController.text,
                              value: valueController.text,
                              status: statuss,
                              ref: ref
                            );
                            GlobalSnackBar.show(
                              context,
                              title: "Updated",
                              message: "Record updated successfully",
                            );

                          } else {
                            await createRecord(
                              title: titleController.text,
                              details: detailsController.text,
                              value: valueController.text,
                              status: statuss,
                              ref: ref
                            );
                            GlobalSnackBar.show(
                              context,
                              title: "Created",
                              message: "Record created successfully",
                              type: CustomSnackType.success,
                            );
                          }
                          context.push(MainApp.routeName);
                        } catch (e) {
                          GlobalSnackBar.show(
                            context,
                            title: "Error",
                            message: e.toString(),
                          );
                        }
                      }
                    },
                    child: Text(isEditing ? 'Update Record' : 'Create Record'),
                  ),
                ),
                SizedBox(height: 12.h),

                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}