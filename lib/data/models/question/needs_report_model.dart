/// Needs Report Model
/// Represents the response from the needs-report API
class NeedsReportModel {
  final List<NeedScore> needScores;
  final List<NeedScore> lowestNeeds;
  final Map<String, CategoryContext> categoryContext;
  final List<Recommendation> recommendations;
  final List<Recommendation> recommendedActions;
  final NeedScore? primaryNeed;
  final String? suggestedPrompt;

  NeedsReportModel({
    required this.needScores,
    required this.lowestNeeds,
    required this.categoryContext,
    required this.recommendations,
    required this.recommendedActions,
    this.primaryNeed,
    this.suggestedPrompt,
  });

  factory NeedsReportModel.fromJson(Map<String, dynamic> json) {
    // Parse needScores - can be List or Map
    List<NeedScore> parsedNeedScores = [];
    if (json['needScores'] != null) {
      if (json['needScores'] is List) {
        // List format
        parsedNeedScores = (json['needScores'] as List<dynamic>)
            .map((e) => NeedScore.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (json['needScores'] is Map) {
        // Map format: { "needKey": { "score": 5, "needLabel": "...", "category": "..." } }
        final needScoresMap = json['needScores'] as Map<String, dynamic>;
        parsedNeedScores = needScoresMap.entries.map((entry) {
          final needKey = entry.key;
          final value = entry.value as Map<String, dynamic>;
          return NeedScore.fromJson({
            'needKey': needKey,
            'needLabel': value['needLabel'] ?? '',
            'score': value['score'] ?? 0.0,
            'category': value['category'] ?? '',
            'learningContentId': value['learningContentId'],
            'hasLearningContent': value['hasLearningContent'] ?? false,
            'questionId': value['questionId'],
          });
        }).toList();
      }
    }

    // Parse lowestNeeds - can be List or Map
    List<NeedScore> parsedLowestNeeds = [];
    if (json['lowestNeeds'] != null) {
      if (json['lowestNeeds'] is List) {
        // List format
        parsedLowestNeeds = (json['lowestNeeds'] as List<dynamic>)
            .map((e) => NeedScore.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (json['lowestNeeds'] is Map) {
        // Map format
        final lowestNeedsMap = json['lowestNeeds'] as Map<String, dynamic>;
        parsedLowestNeeds = lowestNeedsMap.entries.map((entry) {
          final needKey = entry.key;
          final value = entry.value as Map<String, dynamic>;
          return NeedScore.fromJson({
            'needKey': needKey,
            'needLabel': value['needLabel'] ?? '',
            'score': value['score'] ?? 0.0,
            'category': value['category'] ?? '',
            'learningContentId': value['learningContentId'],
            'hasLearningContent': value['hasLearningContent'] ?? false,
            'questionId': value['questionId'],
          });
        }).toList();
      }
    }

    // Parse recommendations
    List<Recommendation> parsedRecommendations = [];
    if (json['recommendations'] != null && json['recommendations'] is List) {
      parsedRecommendations = (json['recommendations'] as List<dynamic>)
          .map((e) => Recommendation.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // Parse recommendedActions
    List<Recommendation> parsedRecommendedActions = [];
    if (json['recommendedActions'] != null && json['recommendedActions'] is List) {
      parsedRecommendedActions = (json['recommendedActions'] as List<dynamic>)
          .map((e) => Recommendation.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // Parse primaryNeed
    NeedScore? parsedPrimaryNeed;
    if (json['primaryNeed'] != null) {
      parsedPrimaryNeed = NeedScore.fromJson(json['primaryNeed'] as Map<String, dynamic>);
    }

    return NeedsReportModel(
      needScores: parsedNeedScores,
      lowestNeeds: parsedLowestNeeds,
      categoryContext: (json['categoryContext'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(
                  key, CategoryContext.fromJson(value as Map<String, dynamic>)))
          ?? {},
      recommendations: parsedRecommendations,
      recommendedActions: parsedRecommendedActions,
      primaryNeed: parsedPrimaryNeed,
      suggestedPrompt: json['suggestedPrompt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'needScores': needScores.map((e) => e.toJson()).toList(),
      'lowestNeeds': lowestNeeds.map((e) => e.toJson()).toList(),
      'categoryContext': categoryContext.map(
          (key, value) => MapEntry(key, value.toJson())),
    };
  }
}

/// Need Score Model
/// Represents a need with its score and metadata
class NeedScore {
  final String needKey;
  final String needLabel;
  final double score;
  final String category;
  final String? learningContentId;
  final bool hasLearningContent;
  final String? questionId;

  NeedScore({
    required this.needKey,
    required this.needLabel,
    required this.score,
    required this.category,
    this.learningContentId,
    required this.hasLearningContent,
    this.questionId,
  });

  factory NeedScore.fromJson(Map<String, dynamic> json) {
    return NeedScore(
      needKey: json['needKey'] as String? ?? '',
      needLabel: json['needLabel'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String? ?? '',
      learningContentId: json['learningContentId']?.toString(),
      hasLearningContent: json['hasLearningContent'] as bool? ?? false,
      questionId: json['questionId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'needKey': needKey,
      'needLabel': needLabel,
      'score': score,
      'category': category,
      'learningContentId': learningContentId,
      'hasLearningContent': hasLearningContent,
      if (questionId != null) 'questionId': questionId,
    };
  }
}

/// Category Context Model
/// Represents context information for a category
class CategoryContext {
  final double averageScore;
  final List<String> needs;

  CategoryContext({
    required this.averageScore,
    required this.needs,
  });

  factory CategoryContext.fromJson(Map<String, dynamic> json) {
    return CategoryContext(
      averageScore: (json['averageScore'] as num?)?.toDouble() ?? 0.0,
      needs: (json['needs'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'averageScore': averageScore,
      'needs': needs,
    };
  }
}

/// Recommendation Model
/// Represents a recommendation or recommended action
class Recommendation {
  final String type; // "learn", "goal", or "coach"
  final String needKey;
  final String needLabel;
  final String? questionId;
  final String message;

  Recommendation({
    required this.type,
    required this.needKey,
    required this.needLabel,
    this.questionId,
    required this.message,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      type: json['type'] as String? ?? '',
      needKey: json['needKey'] as String? ?? '',
      needLabel: json['needLabel'] as String? ?? '',
      questionId: json['questionId']?.toString(),
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'needKey': needKey,
      'needLabel': needLabel,
      if (questionId != null) 'questionId': questionId,
      'message': message,
    };
  }
}

