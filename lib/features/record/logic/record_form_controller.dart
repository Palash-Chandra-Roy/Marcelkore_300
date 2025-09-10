import 'package:supabase_flutter/supabase_flutter.dart';

/// CREATE
Future<void> createRecord({
  required String title,
  required String details,
  String? status,
  required String value,
}) async {
  try {
    final data = await Supabase.instance.client
        .from('records')
        .insert({
      'title': title,
      'details': details,
      'status': status ?? 'active',
      'value': value,
      'user_id': Supabase.instance.client.auth.currentUser!.id,
    })
        .select()
        .single();

    print("✅ Record created: $data");
  } catch (e) {
    print("❌ Create error: $e");
  }
}

/// UPDATE
Future<void> updateRecord({
  required String recordId,
  String? title,
  String? details,
  String? status,
  String? value,
}) async {
  try {
    final updates = {
      if (title != null) 'title': title,
      if (details != null) 'details': details,
      if (status != null) 'status': status,
      if (value != null) 'value': value,
      'updated_at': DateTime.now().toIso8601String(), // optional if you have this column
    };

    final data = await Supabase.instance.client
        .from('records')
        .update(updates)
        .eq('id', recordId)
        .select()
        .single();

    print("✅ Record updated: $data");
  } catch (e) {
    print("❌ Update error: $e");
  }
}

/// DELETE
Future<void> deleteRecord(String recordId) async {
  try {
    final data = await Supabase.instance.client
        .from('records')
        .delete()
        .eq('id', recordId);

    print("✅ Record deleted: $data");
  } catch (e) {
    print("❌ Delete error: $e");
  }
}