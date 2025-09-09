import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/record.dart';

class RecordDetailsController extends GetxController {
  final record = Rxn<Record>();

  /// Optional callbacks
  Function(Record)? onEdit;
  @override
  //Function(String)? onDelete;
  VoidCallback? onBack;

  /// Set the current record
  void setRecord(Record r) {
    record.value = r;
  }

  /// Edit record (callback call)
  void editRecord() {
    if (record.value != null && onEdit != null) {
      onEdit!(record.value!);
    }
  }

  /// Delete record (callback call)
  void deleteRecord() {
    if (record.value != null && onDelete != null) {
      //onDelete!(record.value!.id);
    }
  }

  /// Navigate back
  void goBack() {
    if (onBack != null) {
      onBack!();
    }
  }
}
