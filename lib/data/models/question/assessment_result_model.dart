/// Assessment Result Model
/// Represents the response from the assessment result API
class AssessmentResultModel {
  final String assessmentId;
  final Map<String, int> categoryScores;
  final int overallScore;
  final List<String> lowestCategories;
  final DateTime completedAt;
  final ChartMeta chartMeta;

  AssessmentResultModel({
    required this.assessmentId,
    required this.categoryScores,
    required this.overallScore,
    required this.lowestCategories,
    required this.completedAt,
    required this.chartMeta,
  });

  factory AssessmentResultModel.fromJson(Map<String, dynamic> json) {
    return AssessmentResultModel(
      assessmentId: json['assessmentId'] as String? ?? '',
      categoryScores: (json['categoryScores'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as int))
          ?? {},
      overallScore: json['overallScore'] as int? ?? 0,
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
  final List<int> range;
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
              ?.map((e) => e as int)
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

