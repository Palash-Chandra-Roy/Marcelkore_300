enum RecordStatus { active, pending, archived }

class Record {
  final String? id;
  final String title;
  final String details;
  final RecordStatus status;
  final double value;
  final DateTime updatedAt;

  Record({
    this.id,
    required this.title,
    required this.details,
    required this.status,
    required this.value,
    required this.updatedAt,
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
    id: json['id'] as String?,
    title: json['title'] as String,
    details: json['details'] as String,
    status: RecordStatus.values.firstWhere(
          (s) => s.toString().split('.').last == json['status'],
    ),
    value: (json['value'] as num).toDouble(),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'details': details,
    'status': status.toString().split('.').last,
    'value': value,
    'updated_at': updatedAt.toIso8601String(),
  };
}