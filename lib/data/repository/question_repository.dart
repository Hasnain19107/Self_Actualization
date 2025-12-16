import 'dart:typed_data';
import '../../core/const/api_constants.dart';
import '../../core/utils/debug_utils.dart';
import '../models/api_response_model.dart';
import '../models/question/question_model.dart';
import '../models/question/assessment_submission_model.dart';
import '../models/question/assessment_result_model.dart';
import '../models/question/needs_report_model.dart';
import '../models/question/recommendations_model.dart';
import '../models/question/question_learning_model.dart';
import '../services/api_service.dart';

/// Question Repository
/// Handles all question-related API operations
class QuestionRepository {
  final ApiService _apiService;

  QuestionRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Get questions, optionally filtered by category or categories
  /// Also supports filtering by section, sectionType, parentQuestionId, needKey
  Future<ApiResponseModel<List<QuestionModel>>> getQuestions({
    String? category,
    List<String>? categories,
    int? limit,
    int? page,
    int? section,
    String? sectionType,
    String? parentQuestionId,
    String? needKey,
  }) async {
    try {
      DebugUtils.logInfo(
        'Starting to fetch questions'
        '${category != null ? ' for category: $category' : ''}'
        '${categories != null && categories.isNotEmpty ? ' for categories: ${categories.join(",")}' : ''}',
        tag: 'QuestionRepository.getQuestions',
      );

      final queryParameters = <String, String>{};
      
      if (category != null) {
        queryParameters['category'] = category;
      } else if (categories != null && categories.isNotEmpty) {
        queryParameters['categories'] = categories.join(',');
      }
      
      if (section != null) {
        queryParameters['section'] = section.toString();
      }
      
      if (sectionType != null) {
        queryParameters['sectionType'] = sectionType;
      }
      
      if (parentQuestionId != null) {
        queryParameters['parentQuestionId'] = parentQuestionId;
      }
      
      if (needKey != null) {
        queryParameters['needKey'] = needKey;
      }
      
      if (limit != null) {
        queryParameters['limit'] = limit.toString();
      }
      
      if (page != null) {
        queryParameters['page'] = page.toString();
      }

      final response = await _apiService.get<List<QuestionModel>>(
        endpoint: ApiConstants.questionsEndpoint,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
        includeAuth: true, // Questions now require auth when using categories
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
          'Questions fetched successfully. Total: ${response.data!.length}'
          '${category != null ? ' for $category' : ''}',
          tag: 'QuestionRepository.getQuestions',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to fetch questions'
          '${category != null ? ' for $category' : ''}: ${response.message}',
          tag: 'QuestionRepository.getQuestions',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error fetching questions'
        '${category != null ? ' for $category' : ''}',
        tag: 'QuestionRepository.getQuestions',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<List<QuestionModel>>(
        success: false,
        message: 'Failed to fetch questions'
            '${category != null ? ' for $category' : ''}: ${e.toString()}',
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

  /// Download assessment result as PDF
  Future<ApiResponseModel<Uint8List>> downloadAssessmentPdf() async {
    try {
      DebugUtils.logInfo(
        'Starting to download assessment PDF',
        tag: 'QuestionRepository.downloadAssessmentPdf',
      );

      final response = await _apiService.downloadFile(
        endpoint: ApiConstants.assessmentDownloadPdfEndpoint,
        includeAuth: true,
      );

      if (response.success) {
        DebugUtils.logInfo(
          'Assessment PDF download request succeeded',
          tag: 'QuestionRepository.downloadAssessmentPdf',
        );
      } else {
        DebugUtils.logWarning(
          'Assessment PDF download failed: ${response.message}',
          tag: 'QuestionRepository.downloadAssessmentPdf',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error downloading assessment PDF',
        tag: 'QuestionRepository.downloadAssessmentPdf',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<Uint8List>(
        success: false,
        message: 'Failed to download assessment PDF: ${e.toString()}',
      );
    }
  }

  /// Get needs report (need-level scores)
  Future<ApiResponseModel<NeedsReportModel>> getNeedsReport() async {
    try {
      DebugUtils.logInfo(
        'Starting to fetch needs report',
        tag: 'QuestionRepository.getNeedsReport',
      );

      final response = await _apiService.get<NeedsReportModel>(
        endpoint: ApiConstants.assessmentNeedsReportEndpoint,
        includeAuth: true,
        fromJsonT: (data) {
          if (data is Map<String, dynamic>) {
            return NeedsReportModel.fromJson(data);
          }
          throw Exception('Invalid data format');
        },
      );

      if (response.success && response.data != null) {
        DebugUtils.logInfo(
          'Needs report fetched successfully',
          tag: 'QuestionRepository.getNeedsReport',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to fetch needs report: ${response.message}',
          tag: 'QuestionRepository.getNeedsReport',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error fetching needs report',
        tag: 'QuestionRepository.getNeedsReport',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<NeedsReportModel>(
        success: false,
        message: 'Failed to fetch needs report: ${e.toString()}',
      );
    }
  }

  /// Get recommendations
  Future<ApiResponseModel<RecommendationsModel>> getRecommendations() async {
    try {
      DebugUtils.logInfo(
        'Starting to fetch recommendations',
        tag: 'QuestionRepository.getRecommendations',
      );

      final response = await _apiService.get<RecommendationsModel>(
        endpoint: ApiConstants.assessmentRecommendationsEndpoint,
        includeAuth: true,
        fromJsonT: (data) {
          if (data is Map<String, dynamic>) {
            return RecommendationsModel.fromJson(data);
          }
          throw Exception('Invalid data format');
        },
      );

      if (response.success && response.data != null) {
        DebugUtils.logInfo(
          'Recommendations fetched successfully',
          tag: 'QuestionRepository.getRecommendations',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to fetch recommendations: ${response.message}',
          tag: 'QuestionRepository.getRecommendations',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error fetching recommendations',
        tag: 'QuestionRepository.getRecommendations',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<RecommendationsModel>(
        success: false,
        message: 'Failed to fetch recommendations: ${e.toString()}',
      );
    }
  }

  /// Get question learning content by question ID
  Future<ApiResponseModel<QuestionLearningModel>> getQuestionLearningContent(
    String questionId,
  ) async {
    try {
      DebugUtils.logInfo(
        'Starting to fetch question learning content for question: $questionId',
        tag: 'QuestionRepository.getQuestionLearningContent',
      );

      final response = await _apiService.get<QuestionLearningModel>(
        endpoint: '${ApiConstants.questionLearningByQuestionEndpoint}/$questionId',
        includeAuth: true,
        fromJsonT: (data) {
          if (data is Map<String, dynamic>) {
            return QuestionLearningModel.fromJson(data);
          }
          throw Exception('Invalid data format');
        },
      );

      if (response.success && response.data != null) {
        DebugUtils.logInfo(
          'Question learning content fetched successfully',
          tag: 'QuestionRepository.getQuestionLearningContent',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to fetch question learning content: ${response.message}',
          tag: 'QuestionRepository.getQuestionLearningContent',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error fetching question learning content',
        tag: 'QuestionRepository.getQuestionLearningContent',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<QuestionLearningModel>(
        success: false,
        message: 'Failed to fetch question learning content: ${e.toString()}',
      );
    }
  }

  /// Get question learning content by need key
  Future<ApiResponseModel<List<QuestionLearningModel>>> getQuestionLearningByNeed(
    String needKey,
  ) async {
    try {
      DebugUtils.logInfo(
        'Starting to fetch question learning content for need: $needKey',
        tag: 'QuestionRepository.getQuestionLearningByNeed',
      );

      final queryParameters = <String, String>{
        'needKey': needKey,
      };

      final response = await _apiService.get<List<QuestionLearningModel>>(
        endpoint: ApiConstants.questionLearningEndpoint,
        queryParameters: queryParameters,
        includeAuth: true,
        fromJsonT: (data) {
          if (data is List) {
            return data
                .map((item) => QuestionLearningModel.fromJson(
                    item as Map<String, dynamic>))
                .toList();
          }
          return <QuestionLearningModel>[];
        },
      );

      if (response.success && response.data != null) {
        DebugUtils.logInfo(
          'Question learning content fetched successfully. Total: ${response.data!.length}',
          tag: 'QuestionRepository.getQuestionLearningByNeed',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to fetch question learning content: ${response.message}',
          tag: 'QuestionRepository.getQuestionLearningByNeed',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error fetching question learning content',
        tag: 'QuestionRepository.getQuestionLearningByNeed',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<List<QuestionLearningModel>>(
        success: false,
        message: 'Failed to fetch question learning content: ${e.toString()}',
      );
    }
  }
}

