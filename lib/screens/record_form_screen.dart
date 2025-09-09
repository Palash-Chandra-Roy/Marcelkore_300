import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/record.dart';
import '../controller/record_form_controller.dart';

class RecordFormScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(recordFormProvider.notifier);
    final state = ref.watch(recordFormProvider);

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
          TextButton(
            onPressed: state.isLoading
                ? null
                : () async {
              final saved = await controller.saveRecord(context);
              if (saved != null) {
                onSave(saved);
              }
            },
            child: state.isLoading
                ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Text('Save'),
          ),
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
                validator: (value) => value == null || value.trim().isEmpty
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
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter details'
                    : (value.trim().length < 10
                    ? 'Details must be at least 10 characters'
                    : null),
              ),
              const SizedBox(height: 24),

              // Status
              Text('Status', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              DropdownButtonFormField<RecordStatus>(
                value: state.selectedStatus,
                onChanged: (newValue) {
                  if (newValue != null) {
                    controller.setStatus(newValue);
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
              ),
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
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () async {
                    final saved = await controller.saveRecord(context);
                    if (saved != null) {
                      onSave(saved);
                    }
                  },
                  child: state.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isEditing ? 'Update Record' : 'Create Record'),
                ),
              ),
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