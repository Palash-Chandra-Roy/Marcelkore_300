// models/record_data.dart
import 'package:equatable/equatable.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecordData extends Equatable {
  final String id;
  final String title;
  final String details;
  final String status;
  final double value;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RecordData({
    required this.id,
    required this.title,
    required this.details,
    required this.status,
    required this.value,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RecordData.fromMap(Map<String, dynamic> map) {
    return RecordData(
      id: map['id'] as String,
      title: map['title'] ?? '',
      details: map['details'] ?? '',
      status: map['status'] ?? 'active',
      value: (map['value'] is int)
          ? (map['value'] as int).toDouble()
          : (map['value'] ?? 0.0).toDouble(),
      userId: map['user_id'] as String,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  @override
  List<Object?> get props => [id, title, details, status, value, userId, createdAt, updatedAt];
  /// Human-readable text
  String get createdAgo => timeago.format(createdAt);
  String get updatedAgo => timeago.format(updatedAt);
}