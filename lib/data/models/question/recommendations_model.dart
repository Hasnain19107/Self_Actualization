import 'needs_report_model.dart';

/// Recommendations Model
/// Represents the response from the recommendations API
class RecommendationsModel {
  final List<RecommendedAction> recommendedActions;
  final List<NeedScore> lowestNeeds;
  final String suggestedPrompt;

  RecommendationsModel({
    required this.recommendedActions,
    required this.lowestNeeds,
    required this.suggestedPrompt,
  });

  factory RecommendationsModel.fromJson(Map<String, dynamic> json) {
    return RecommendationsModel(
      recommendedActions: (json['recommendedActions'] as List<dynamic>?)
              ?.map((e) => RecommendedAction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lowestNeeds: (json['lowestNeeds'] as List<dynamic>?)
              ?.map((e) => NeedScore.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      suggestedPrompt: json['suggestedPrompt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recommendedActions':
          recommendedActions.map((e) => e.toJson()).toList(),
      'lowestNeeds': lowestNeeds.map((e) => e.toJson()).toList(),
      'suggestedPrompt': suggestedPrompt,
    };
  }
}

/// Recommended Action Model
/// Represents a recommended action for a need
class RecommendedAction {
  final String type; // 'learn', 'goal', 'coach'
  final String needKey;
  final String needLabel;
  final String message;
  final String? learningContentId;

  RecommendedAction({
    required this.type,
    required this.needKey,
    required this.needLabel,
    required this.message,
    this.learningContentId,
  });

  factory RecommendedAction.fromJson(Map<String, dynamic> json) {
    return RecommendedAction(
      type: json['type'] as String? ?? '',
      needKey: json['needKey'] as String? ?? '',
      needLabel: json['needLabel'] as String? ?? '',
      message: json['message'] as String? ?? '',
      learningContentId: json['learningContentId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'needKey': needKey,
      'needLabel': needLabel,
      'message': message,
      'learningContentId': learningContentId,
    };
  }
}

