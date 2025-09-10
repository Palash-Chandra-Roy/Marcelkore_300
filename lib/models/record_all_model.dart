enum RecordStatus { active, pending, archived }

class Record {
  final String? id; // Supabase auto-generate করবে (nullable on create)
  final String title;
  final String details;
  final RecordStatus status;
  final double value;
  final DateTime updatedAt;
  final DateTime? createdAt; // optional, Supabase default now()

  const Record({
    this.id,
    required this.title,
    required this.details,
    required this.status,
    required this.value,
    required this.updatedAt,
    this.createdAt,
  });

  /// Convert Enum → String (for DB insert/update)
  String get statusString => status.toString().split('.').last;

  /// Convert String → Enum (from DB)
  static RecordStatus statusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return RecordStatus.active;
      case 'pending':
        return RecordStatus.pending;
      case 'archived':
        return RecordStatus.archived;
      default:
        return RecordStatus.active;
    }
  }

  /// From Supabase JSON
  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json['id']?.toString(), // nullable
      title: json['title'] ?? '',
      details: json['details'] ?? '',
      status: statusFromString(json['status'] ?? 'active'),
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      updatedAt: DateTime.tryParse(
        json['updated_at']?.toString() ?? '',
      ) ??
          DateTime.now(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  /// To Supabase JSON
  Map<String, dynamic> toJson() {
    final map = {
      'title': title,
      'details': details,
      'status': statusString,
      'value': value,
      'updated_at': updatedAt.toIso8601String(),
    };

    if (id != null) {
      map['id'] = id!; // ❌ as Object লাগবে না
    }
    return map;
  }


  /// CopyWith for immutability
  Record copyWith({
    String? id,
    String? title,
    String? details,
    RecordStatus? status,
    double? value,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return Record(
      id: id ?? this.id,
      title: title ?? this.title,
      details: details ?? this.details,
      status: status ?? this.status,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}