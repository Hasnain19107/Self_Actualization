/// Goal Request Model
/// Represents the payload to create a new goal
class GoalRequestModel {
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String type;
  final String? needKey;
  final String? needLabel;
  final int? needOrder;
  final String? questionId;

  GoalRequestModel({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.type,
    this.needKey,
    this.needLabel,
    this.needOrder,
    this.questionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'type': type,
      'needKey': needKey,
      'needLabel': needLabel,
      'needOrder': needOrder,
      'questionId': questionId,
    };
  }
}

