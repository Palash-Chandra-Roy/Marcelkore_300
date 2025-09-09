import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/record.dart';

class RecordDetailsController extends StateNotifier<Record?> {
  RecordDetailsController() : super(null);

  Function(Record)? onEdit;
  Function(String)? onDelete;
  VoidCallback? onBack;

  void setRecord(Record r) {
    state = r;
  }

  void editRecord() {
    if (state != null && onEdit != null) {
      onEdit!(state!);
    }
  }

  void deleteRecord() {
    if (state != null && onDelete != null) {
      onDelete!(state!.id);
    }
  }

  void goBack() {
    if (onBack != null) {
      onBack!();
    }
  }
}

/// Provider
final recordDetailsProvider =
StateNotifierProvider<RecordDetailsController, Record?>(
        (ref) => RecordDetailsController());