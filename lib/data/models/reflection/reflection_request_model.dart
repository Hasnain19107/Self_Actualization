/// Reflection Request Model
/// Model for creating a reflection
class ReflectionRequestModel {
  final String mood;
  final String note;

  ReflectionRequestModel({
    required this.mood,
    required this.note,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'mood': mood,
      'note': note,
    };
  }
}

