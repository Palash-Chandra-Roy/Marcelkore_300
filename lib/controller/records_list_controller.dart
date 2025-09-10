import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/record_all_model.dart';
import '../services/supabase_service.dart';

class RecordsState {
  final List<Record> records;
  final bool isLoading;
  final String error;
  final String searchQuery;
  final RecordStatus? statusFilter;

  const RecordsState({
    this.records = const [],
    this.isLoading = false,
    this.error = "",
    this.searchQuery = "",
    this.statusFilter,
  });

  RecordsState copyWith({
    List<Record>? records,
    bool? isLoading,
    String? error,
    String? searchQuery,
    RecordStatus? statusFilter,
  }) {
    return RecordsState(
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }
}

class RecordsController extends StateNotifier<RecordsState> {
  RecordsController() : super(const RecordsState()) {
    loadRecords();
  }

  Future<void> loadRecords() async {
    try {
      state = state.copyWith(isLoading: true, error: "");
      final result = await SupabaseService.getRecords();
      state = state.copyWith(records: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> deleteRecord(String id) async {
    try {
      await SupabaseService.deleteRecord(id);
      state = state.copyWith(
        records: state.records.where((r) => r.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: "Failed to delete record: $e");
    }
  }

  void setSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setStatusFilter(RecordStatus? status) {
    state = state.copyWith(statusFilter: status);
  }

  List<Record> get filteredRecords {
    return state.records.where((record) {
      final matchesSearch =
          record.title.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
              record.details
                  .toLowerCase()
                  .contains(state.searchQuery.toLowerCase());
      final matchesStatus =
          state.statusFilter == null || record.status == state.statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }
}

final recordsProvider =
StateNotifierProvider<RecordsController, RecordsState>(
      (ref) => RecordsController(),
);