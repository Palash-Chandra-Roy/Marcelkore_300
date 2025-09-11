import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/core/utils/fetch_function.dart';
import 'package:my_app/models/record_data.dart';


final recordCountProvider = Provider<int>((ref) {
  final asyncRecords = ref.watch(recordsStreamProvider);

  return asyncRecords.when(
    data: (records) => records.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});