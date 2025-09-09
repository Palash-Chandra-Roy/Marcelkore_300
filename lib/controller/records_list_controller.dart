import 'package:get/get.dart';
import '../models/record.dart';
import '../services/supabase_service.dart';

class RecordsController extends GetxController {
  var records = <Record>[].obs;
  var isLoading = false.obs;
  var error = "".obs;

  var searchQuery = "".obs;
  var statusFilter = Rxn<RecordStatus>();

  @override
  void onInit() {
    super.onInit();
    loadRecords();
  }

  Future<void> loadRecords() async {
    try {
      isLoading.value = true;
      error.value = "";

      final result = await SupabaseService.getRecords();
      records.assignAll(result);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteRecord(String id) async {
    try {
      await SupabaseService.deleteRecord(id);
      records.removeWhere((r) => r.id == id);
    } catch (e) {
      Get.snackbar("Error", "Failed to delete record: $e");
    }
  }

  List<Record> get filteredRecords {
    return records.where((record) {
      final matchesSearch = record.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          record.details.toLowerCase().contains(searchQuery.value.toLowerCase());
      final matchesStatus = statusFilter.value == null || record.status == statusFilter.value;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  void setSearch(String query) {
    searchQuery.value = query;
  }

  void setStatusFilter(RecordStatus? status) {
    statusFilter.value = status;
  }
}
