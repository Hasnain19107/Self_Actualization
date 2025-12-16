/// Goal Need Model
/// Represents a need item from the goals/needs API
class GoalNeedModel {
  final String needKey;
  final String needLabel;
  final int needOrder;
  final String category;
  final String? questionId;

  GoalNeedModel({
    required this.needKey,
    required this.needLabel,
    required this.needOrder,
    required this.category,
    this.questionId,
  });

  factory GoalNeedModel.fromJson(Map<String, dynamic> json) {
    return GoalNeedModel(
      needKey: json['needKey'] as String? ?? '',
      needLabel: json['needLabel'] as String? ?? '',
      needOrder: (json['needOrder'] as num?)?.toInt() ?? 0,
      category: json['category'] as String? ?? '',
      questionId: json['questionId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'needKey': needKey,
      'needLabel': needLabel,
      'needOrder': needOrder,
      'category': category,
      if (questionId != null) 'questionId': questionId,
    };
  }
}

/// Goal Needs Response Model
/// Represents the response from goals/needs/{category} endpoint
class GoalNeedsResponseModel {
  final bool success;
  final String category;
  final int total;
  final List<GoalNeedModel> data;

  GoalNeedsResponseModel({
    required this.success,
    required this.category,
    required this.total,
    required this.data,
  });

  factory GoalNeedsResponseModel.fromJson(Map<String, dynamic> json) {
    return GoalNeedsResponseModel(
      success: json['success'] as bool? ?? false,
      category: json['category'] as String? ?? '',
      total: (json['total'] as num?)?.toInt() ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => GoalNeedModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'category': category,
      'total': total,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

