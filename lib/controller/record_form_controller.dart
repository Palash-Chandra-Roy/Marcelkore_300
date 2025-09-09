import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/record.dart';
import '../services/supabase_service.dart';

class RecordFormController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final detailsController = TextEditingController();
  final valueController = TextEditingController();

  final isLoading = false.obs;
  final selectedStatus = RecordStatus.active.obs;

  Record? editingRecord;

  void setRecord(Record? record) {
    editingRecord = record;
    if (record != null) {
      titleController.text = record.title;
      detailsController.text = record.details;
      valueController.text = record.value.toString();
      selectedStatus.value = record.status;
    }
  }

  Future<Record?> saveRecord() async {
    if (!formKey.currentState!.validate()) return null;

    try {
      isLoading.value = true;
      final record = Record(
        id: editingRecord?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text.trim(),
        details: detailsController.text.trim(),
        status: selectedStatus.value,
        value: double.parse(valueController.text),
        updatedAt: DateTime.now(),
      );

      final saved = editingRecord != null
          ? await SupabaseService.updateRecord(record)
          : await SupabaseService.createRecord(record);

      return saved;
    } catch (e) {
      Get.snackbar("Error", "Failed to save record: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    detailsController.dispose();
    valueController.dispose();
    super.onClose();
  }
}
