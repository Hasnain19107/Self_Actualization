/// Assessment Result Model
/// Represents the response from the assessment result API
class AssessmentResultModel {
  final String assessmentId;
  final Map<String, double> categoryScores;
  final Map<String, double> needScores; // New: need-level scores
  final double overallScore;
  final List<String> lowestCategories;
  final DateTime completedAt;
  final ChartMeta chartMeta;

  AssessmentResultModel({
    required this.assessmentId,
    required this.categoryScores,
    required this.needScores,
    required this.overallScore,
    required this.lowestCategories,
    required this.completedAt,
    required this.chartMeta,
  });

  factory AssessmentResultModel.fromJson(Map<String, dynamic> json) {
    // Parse needScores - it can be either:
    // 1. Map<String, num> (simple scores)
    // 2. Map<String, Map> (objects with score, needLabel, category)
    Map<String, double> parsedNeedScores = {};
    if (json['needScores'] != null) {
      final needScoresData = json['needScores'] as Map<String, dynamic>;
      needScoresData.forEach((key, value) {
        if (value is num) {
          // Simple numeric value
          parsedNeedScores[key] = value.toDouble();
        } else if (value is Map<String, dynamic>) {
          // Object with score, needLabel, category
          final score = value['score'];
          if (score is num) {
            parsedNeedScores[key] = score.toDouble();
          }
        }
      });
    }

    return AssessmentResultModel(
      assessmentId: json['assessmentId'] as String? ?? '',
      categoryScores: (json['categoryScores'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, (value as num).toDouble()))
          ?? {},
      needScores: parsedNeedScores,
      overallScore: (json['overallScore'] as num?)?.toDouble() ?? 0.0,
      lowestCategories: (json['lowestCategories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      chartMeta: json['chartMeta'] != null
          ? ChartMeta.fromJson(json['chartMeta'] as Map<String, dynamic>)
          : ChartMeta.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assessmentId': assessmentId,
      'categoryScores': categoryScores,
      'needScores': needScores,
      'overallScore': overallScore,
      'lowestCategories': lowestCategories,
      'completedAt': completedAt.toIso8601String(),
      'chartMeta': chartMeta.toJson(),
    };
  }
}

/// Chart Meta Model
/// Contains performance bands and category descriptions
class ChartMeta {
  final List<PerformanceBand> performanceBands;
  final Map<String, String> categoryDescriptions;

  ChartMeta({
    required this.performanceBands,
    required this.categoryDescriptions,
  });

  factory ChartMeta.fromJson(Map<String, dynamic> json) {
    return ChartMeta(
      performanceBands: (json['performanceBands'] as List<dynamic>?)
              ?.map((e) => PerformanceBand.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      categoryDescriptions: (json['categoryDescriptions'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value.toString()))
          ?? {},
    );
  }

  factory ChartMeta.empty() {
    return ChartMeta(
      performanceBands: [],
      categoryDescriptions: {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'performanceBands': performanceBands.map((e) => e.toJson()).toList(),
      'categoryDescriptions': categoryDescriptions,
    };
  }
}

/// Performance Band Model
/// Represents a performance band with label, range, and color
class PerformanceBand {
  final String label;
  final List<double> range;
  final String color;

  PerformanceBand({
    required this.label,
    required this.range,
    required this.color,
  });

  factory PerformanceBand.fromJson(Map<String, dynamic> json) {
    return PerformanceBand(
      label: json['label'] as String? ?? '',
      range: (json['range'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      color: json['color'] as String? ?? '#000000',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'range': range,
      'color': color,
    };
  }
}

