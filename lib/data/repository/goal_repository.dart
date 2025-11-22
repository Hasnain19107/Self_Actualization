import '../../core/const/api_constants.dart';
import '../../core/utils/debug_utils.dart';
import '../models/api_response_model.dart';
import '../models/goal/goal_model.dart';
import '../models/goal/goal_request_model.dart';
import '../services/api_service.dart';

/// Goal Repository
/// Handles goal related API operations
class GoalRepository {
  final ApiService _apiService;

  GoalRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<ApiResponseModel<Map<String, dynamic>>> createGoal(
    GoalRequestModel request,
  ) async {
    try {
      DebugUtils.logInfo(
        'Creating new goal',
        tag: 'GoalRepository.createGoal',
      );

      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: ApiConstants.goalsEndpoint,
        body: request.toJson(),
        includeAuth: true,
        fromJsonT: (data) => data as Map<String, dynamic>,
      );

      if (response.success) {
        DebugUtils.logInfo(
          'Goal created successfully',
          tag: 'GoalRepository.createGoal',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to create goal: ${response.message}',
          tag: 'GoalRepository.createGoal',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error creating goal',
        tag: 'GoalRepository.createGoal',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<Map<String, dynamic>>(
        success: false,
        message: 'Failed to create goal: ${e.toString()}',
      );
    }
  }

  Future<ApiResponseModel<List<GoalModel>>> getGoals({
    String? status,
  }) async {
    try {
      DebugUtils.logInfo(
        'Fetching goals',
        tag: 'GoalRepository.getGoals',
      );

      final response = await _apiService.get<List<GoalModel>>(
        endpoint: ApiConstants.goalsEndpoint,
        queryParameters: status != null ? {'status': status} : null,
        includeAuth: true,
        fromJsonT: (data) {
          if (data is List) {
            return data
                .map((item) => GoalModel.fromJson(item as Map<String, dynamic>))
                .toList();
          }
          return <GoalModel>[];
        },
      );

      if (response.success && response.data != null) {
        DebugUtils.logInfo(
          'Goals fetched successfully. Total: ${response.data!.length}',
          tag: 'GoalRepository.getGoals',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to fetch goals: ${response.message}',
          tag: 'GoalRepository.getGoals',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error fetching goals',
        tag: 'GoalRepository.getGoals',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<List<GoalModel>>(
        success: false,
        message: 'Failed to fetch goals: ${e.toString()}',
      );
    }
  }
}

