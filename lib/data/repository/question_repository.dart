import '../../core/const/api_constants.dart';
import '../../core/utils/debug_utils.dart';
import '../models/api_response_model.dart';
import '../models/question/question_model.dart';
import '../models/question/assessment_submission_model.dart';
import '../models/question/assessment_result_model.dart';
import '../services/api_service.dart';

/// Question Repository
/// Handles all question-related API operations
class QuestionRepository {
  final ApiService _apiService;

  QuestionRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Get all questions
  Future<ApiResponseModel<List<QuestionModel>>> getQuestions() async {
    try {
      DebugUtils.logInfo(
        'Starting to fetch questions',
        tag: 'QuestionRepository.getQuestions',
      );

      final response = await _apiService.get<List<QuestionModel>>(
        endpoint: ApiConstants.questionsEndpoint,
        includeAuth: false,
        fromJsonT: (data) {
          // The API returns { success, total, data: [...] }
          // The 'data' field is already extracted by ApiResponseModel
          // So 'data' parameter here is the list of questions
          if (data is List) {
            return data
                .map((item) => QuestionModel.fromJson(
                    item as Map<String, dynamic>))
                .toList();
          }
          return <QuestionModel>[];
        },
      );

      if (response.success && response.data != null) {
        DebugUtils.logInfo(
          'Questions fetched successfully. Total: ${response.data!.length}',
          tag: 'QuestionRepository.getQuestions',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to fetch questions: ${response.message}',
          tag: 'QuestionRepository.getQuestions',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error fetching questions',
        tag: 'QuestionRepository.getQuestions',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<List<QuestionModel>>(
        success: false,
        message: 'Failed to fetch questions: ${e.toString()}',
      );
    }
  }

  /// Submit assessment answers
  Future<ApiResponseModel<Map<String, dynamic>>> submitAssessment(
    AssessmentSubmissionModel submission,
  ) async {
    try {
      final submissionJson = submission.toJson();
      
      DebugUtils.logInfo(
        'Starting to submit assessment',
        tag: 'QuestionRepository.submitAssessment',
      );
      
      DebugUtils.logInfo(
        'Submission data: ${submissionJson.toString()}',
        tag: 'QuestionRepository.submitAssessment',
      );
      
      DebugUtils.logInfo(
        'Responses count: ${submission.responses.length}',
        tag: 'QuestionRepository.submitAssessment',
      );

      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: ApiConstants.assessmentSubmitEndpoint,
        body: submissionJson,
        includeAuth: true, // Assessment submission requires authentication
        fromJsonT: (data) => data as Map<String, dynamic>,
      );

      if (response.success) {
        DebugUtils.logInfo(
          'Assessment submitted successfully',
          tag: 'QuestionRepository.submitAssessment',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to submit assessment: ${response.message}',
          tag: 'QuestionRepository.submitAssessment',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error submitting assessment',
        tag: 'QuestionRepository.submitAssessment',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<Map<String, dynamic>>(
        success: false,
        message: 'Failed to submit assessment: ${e.toString()}',
      );
    }
  }

  /// Get assessment result
  Future<ApiResponseModel<AssessmentResultModel>> getAssessmentResult() async {
    try {
      DebugUtils.logInfo(
        'Starting to fetch assessment result',
        tag: 'QuestionRepository.getAssessmentResult',
      );

      final response = await _apiService.get<AssessmentResultModel>(
        endpoint: ApiConstants.assessmentResultEndpoint,
        includeAuth: true, // Assessment result requires authentication
        fromJsonT: (data) {
          // The 'data' parameter is already the assessment result object
          if (data is Map<String, dynamic>) {
            return AssessmentResultModel.fromJson(data);
          }
          throw Exception('Invalid data format');
        },
      );

      // ApiResponseModel already extracts the data field, so response.data is the AssessmentResultModel
      if (response.success && response.data != null) {
        DebugUtils.logInfo(
          'Assessment result fetched successfully',
          tag: 'QuestionRepository.getAssessmentResult',
        );
        
        return response;
      }

      DebugUtils.logWarning(
        'Failed to fetch assessment result: ${response.message}',
        tag: 'QuestionRepository.getAssessmentResult',
      );

      return ApiResponseModel<AssessmentResultModel>(
        success: false,
        message: response.message.isNotEmpty
            ? response.message
            : 'Failed to fetch assessment result',
        statusCode: response.statusCode,
      );
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error fetching assessment result',
        tag: 'QuestionRepository.getAssessmentResult',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<AssessmentResultModel>(
        success: false,
        message: 'Failed to fetch assessment result: ${e.toString()}',
      );
    }
  }
}

