enum RecordStatus { active, pending, archived }

class Record {
  final String id;
  final String title;
  final String details;
  final RecordStatus status;
  final double value;
  final DateTime updatedAt;

  Record({
    required this.id,
    required this.title,
    required this.details,
    required this.status,
    required this.value,
    required this.updatedAt,
  });

  String get statusString {
    switch (status) {
      case RecordStatus.active:
        return 'Active';
      case RecordStatus.pending:
        return 'Pending';
      case RecordStatus.archived:
        return 'Archived';
    }
  }

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

  /// Create Record from JSON (for API responses)
  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      details: json['details'] ?? '',
      status: RecordStatus.values.firstWhere(
        (e) => e.toString().split('.').last.toLowerCase() == 
               (json['status']?.toString().toLowerCase() ?? 'active'),
        orElse: () => RecordStatus.active,
      ),
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      updatedAt: json['updated_at'] != null 
        ? DateTime.parse(json['updated_at']) 
        : (json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now()),
    );
  }

  /// Convert Record to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'details': details,
      'status': status.toString().split('.').last,
      'value': value,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Record copyWith({
    String? id,
    String? title,
    String? details,
    RecordStatus? status,
    double? value,
    DateTime? updatedAt,
  }) {
    return Record(
      id: id ?? this.id,
      title: title ?? this.title,
      details: details ?? this.details,
      status: status ?? this.status,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Sample data
  static List<Record> getSampleRecords() {
    return [
      Record(
        id: '1',
        title: 'Project Alpha',
        details: 'Main development project for Q1',
        status: RecordStatus.active,
        value: 15900.0,
        updatedAt: DateTime.now().subtract(const Duration(hours: 7)),
      ),
      Record(
        id: '2',
        title: 'Client Meeting',
        details: 'Quarterly review with stakeholders',
        status: RecordStatus.pending,
        value: 5400.0,
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Record(
        id: '3',
        title: 'Documentation',
        details: 'API documentation and user guides',
        status: RecordStatus.archived,
        value: 8500.0,
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Record(
        id: '4',
        title: 'Bug Fixes',
        details: 'Critical bug fixes for production',
        status: RecordStatus.active,
        value: 3200.0,
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
  }
}