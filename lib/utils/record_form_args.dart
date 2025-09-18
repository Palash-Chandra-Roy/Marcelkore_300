import 'dart:ffi';

class RecordFormArgs {
  final String? id;            // required
  final String? title;        // optional
  final double? value;        // optional
  final String? details;      // optional
  final String? status;       // optional

  RecordFormArgs({
    this.id,
    this.title,
    this.value,
    this.details,
    this.status,
  });
}