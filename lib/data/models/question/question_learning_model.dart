import '../question/question_model.dart';

/// Question Learning Content Model
/// Represents learning content linked to a question/need
class QuestionLearningModel {
  final String id;
  final QuestionModel question;
  final String title;
  final String content;
  final String learningType; // 'article', 'video', 'audio'
  final String? thumbnailUrl;
  final int readTimeMinutes;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  QuestionLearningModel({
    required this.id,
    required this.question,
    required this.title,
    required this.content,
    required this.learningType,
    this.thumbnailUrl,
    required this.readTimeMinutes,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory QuestionLearningModel.fromJson(Map<String, dynamic> json) {
    return QuestionLearningModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      question: json['questionId'] != null
          ? QuestionModel.fromJson(
              json['questionId'] as Map<String, dynamic>)
          : QuestionModel(
              id: '',
              questionText: '',
              answerOptions: [],
              pointValue: 0,
              category: '',
              questionType: '',
              isActive: false,
            ),
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      learningType: json['learningType'] as String? ?? 'article',
      thumbnailUrl: json['thumbnailUrl']?.toString(),
      readTimeMinutes: (json['readTimeMinutes'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'questionId': question.toJson(),
      'title': title,
      'content': content,
      'learningType': learningType,
      'thumbnailUrl': thumbnailUrl,
      'readTimeMinutes': readTimeMinutes,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

