/// Question Model
/// Represents a question from the API
class QuestionModel {
  final String id;
  final String questionText;
  final List<String> answerOptions;
  final String? correctAnswer;
  final int pointValue;
  final String category;
  final String questionType;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  QuestionModel({
    required this.id,
    required this.questionText,
    required this.answerOptions,
    this.correctAnswer,
    required this.pointValue,
    required this.category,
    required this.questionType,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  /// Create from JSON
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      questionText: json['questionText'] as String? ?? '',
      answerOptions: (json['answerOptions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      correctAnswer: json['correctAnswer']?.toString(),
      pointValue: json['pointValue'] as int? ?? 0,
      category: json['category'] as String? ?? '',
      questionType: json['questionType'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'questionText': questionText,
      'answerOptions': answerOptions,
      'correctAnswer': correctAnswer,
      'pointValue': pointValue,
      'category': category,
      'questionType': questionType,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

