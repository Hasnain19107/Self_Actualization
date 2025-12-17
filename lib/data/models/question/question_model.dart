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
  
  // New fields for need-level metadata
  final String? needKey;
  final String? needLabel;
  final int? needOrder;
  final int? section;
  final String? sectionType;
  final String? parentQuestionId;
  final int? sectionOrder;

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
    this.needKey,
    this.needLabel,
    this.needOrder,
    this.section,
    this.sectionType,
    this.parentQuestionId,
    this.sectionOrder,
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
      needKey: json['needKey']?.toString(),
      needLabel: json['needLabel']?.toString(),
      needOrder: json['needOrder'] as int?,
      section: json['section'] as int?,
      sectionType: json['sectionType']?.toString(),
      parentQuestionId: json['parentQuestionId']?.toString(),
      sectionOrder: json['sectionOrder'] as int?,
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
      'needKey': needKey,
      'needLabel': needLabel,
      'needOrder': needOrder,
      'section': section,
      'sectionType': sectionType,
      'parentQuestionId': parentQuestionId,
      'sectionOrder': sectionOrder,
    };
  }
}

