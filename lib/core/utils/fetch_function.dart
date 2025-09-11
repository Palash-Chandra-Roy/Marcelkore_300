import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/models/record_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


final recordsStreamProvider = StreamProvider.autoDispose<List<RecordData>>((ref) {
  final userId = Supabase.instance.client.auth.currentUser!.id;

  // Supabase stream listener
  final stream = Supabase.instance.client
      .from('records')
      .stream(primaryKey: ['id'])
      .eq('user_id', userId)
      .map((data) => data.map((e) => RecordData.fromMap(e)).toList());

  return stream;
});