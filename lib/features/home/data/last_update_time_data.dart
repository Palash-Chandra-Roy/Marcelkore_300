import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/core/utils/fetch_function.dart';

class LastActivity {
  final String lastCreated;
  final String lastUpdated;

  LastActivity({
    required this.lastCreated,
    required this.lastUpdated,
  });
}

/// Custom formatter function
String formatDuration(DateTime time) {
  final now = DateTime.now();
  final diff = now.difference(time);

  if (diff.inMinutes < 60) {
    return "${diff.inMinutes}m"; // মিনিট হলে M দেখাবে
  } else if (diff.inHours < 24) {
    return "${diff.inHours}h"; // ঘন্টা হলে H দেখাবে
  } else {
    return "${diff.inDays}d"; // চাইলে extra হিসেবে দিনও দেখাতে পারো
  }
}

final lastActivityProvider = Provider<LastActivity>((ref) {
  final asyncRecords = ref.watch(recordsStreamProvider);

  return asyncRecords.when(
    data: (records) {
      if (records.isEmpty) {
        return LastActivity(lastCreated: "N/A", lastUpdated: "N/A");
      }

      // সর্বশেষ created_at
      records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final lastCreated = formatDuration(records.first.createdAt);

      // সর্বশেষ updated_at
      records.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      final lastUpdated = formatDuration(records.first.updatedAt);

      return LastActivity(lastCreated: lastCreated, lastUpdated: lastUpdated);
    },
    loading: () => LastActivity(lastCreated: "...", lastUpdated: "..."),
    error: (_, __) => LastActivity(lastCreated: "Err", lastUpdated: "Err"),
  );
});