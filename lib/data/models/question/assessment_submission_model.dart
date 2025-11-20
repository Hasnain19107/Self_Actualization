/// Assessment Submission Model
/// Represents the request body for submitting an assessment
class AssessmentSubmissionModel {
  final List<Map<String, dynamic>> responses;

  AssessmentSubmissionModel({
    required this.responses,
  });

  /// Create from map of answers (questionId -> selectedOption)
  factory AssessmentSubmissionModel.fromAnswerMap(
    Map<String, int> answerMap,
  ) {
    final responsesList = answerMap.entries.map((entry) {
      return {
        'questionId': entry.key,
        'selectedOption': entry.value,
      };
    }).toList();

    return AssessmentSubmissionModel(
      responses: responsesList,
    );
  }

  /// Create from list of responses
  factory AssessmentSubmissionModel.fromResponses(
    List<Map<String, dynamic>> responsesList,
  ) {
    return AssessmentSubmissionModel(
      responses: responsesList,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'responses': responses,
    };
  }
}

