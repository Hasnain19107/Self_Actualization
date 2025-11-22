/// Reflection Model
/// Represents a reflection from the API
class ReflectionModel {
  final String id;
  final String userId;
  final String mood;
  final String note;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReflectionModel({
    required this.id,
    required this.userId,
    required this.mood,
    required this.note,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from JSON
  factory ReflectionModel.fromJson(Map<String, dynamic> json) {
    return ReflectionModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      mood: json['mood'] as String? ?? '',
      note: json['note'] as String? ?? '',
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'mood': mood,
      'note': note,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

