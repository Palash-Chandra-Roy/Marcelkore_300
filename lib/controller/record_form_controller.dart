import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/record.dart';
import '../services/supabase_service.dart';

class RecordFormState {
  final bool isLoading;
  final RecordStatus selectedStatus;

  const RecordFormState({
    this.isLoading = false,
    this.selectedStatus = RecordStatus.active,
  });

  RecordFormState copyWith({
    bool? isLoading,
    RecordStatus? selectedStatus,
  }) {
    return RecordFormState(
      isLoading: isLoading ?? this.isLoading,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }
}

class RecordFormController extends StateNotifier<RecordFormState> {
  RecordFormController() : super(const RecordFormState());

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final detailsController = TextEditingController();
  final valueController = TextEditingController();

  Record? editingRecord;

  void setRecord(Record? record) {
    editingRecord = record;
    if (record != null) {
      titleController.text = record.title;
      detailsController.text = record.details;
      valueController.text = record.value.toString();
      state = state.copyWith(selectedStatus: record.status);
    }
  }

  void setStatus(RecordStatus status) {
    state = state.copyWith(selectedStatus: status);
  }

  Future<Record?> saveRecord(BuildContext context) async {
    if (!formKey.currentState!.validate()) return null;

    try {
      state = state.copyWith(isLoading: true);

      final record = Record(
        id: editingRecord?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text.trim(),
        details: detailsController.text.trim(),
        status: state.selectedStatus,
        value: double.tryParse(valueController.text.trim()) ?? 0.0,
        updatedAt: DateTime.now(),
      );

      final saved = editingRecord != null
          ? await SupabaseService.updateRecord(record)
          : await SupabaseService.createRecord(record);

      if (saved == null) {
        throw Exception("Supabase returned null when saving record");
      }

      return saved;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to save record: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    detailsController.dispose();
    valueController.dispose();
    super.dispose();
  }
}

/// Provider
final recordFormProvider =
StateNotifierProvider<RecordFormController, RecordFormState>(
      (ref) => RecordFormController(),
);