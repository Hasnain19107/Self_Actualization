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

  /// Get a single goal by ID
  Future<ApiResponseModel<GoalModel>> getGoalById(String goalId) async {
    try {
      DebugUtils.logInfo(
        'Fetching goal by ID: $goalId',
        tag: 'GoalRepository.getGoalById',
      );

      final response = await _apiService.get<GoalModel>(
        endpoint: '${ApiConstants.goalsEndpoint}/$goalId',
        includeAuth: true,
        fromJsonT: (data) => GoalModel.fromJson(data as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        DebugUtils.logInfo(
          'Goal fetched successfully',
          tag: 'GoalRepository.getGoalById',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to fetch goal: ${response.message}',
          tag: 'GoalRepository.getGoalById',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error fetching goal',
        tag: 'GoalRepository.getGoalById',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<GoalModel>(
        success: false,
        message: 'Failed to fetch goal: ${e.toString()}',
      );
    }
  }

  /// Complete a goal
  Future<ApiResponseModel<GoalModel>> completeGoal(String goalId) async {
    try {
      DebugUtils.logInfo(
        'Completing goal: $goalId',
        tag: 'GoalRepository.completeGoal',
      );

      final response = await _apiService.post<GoalModel>(
        endpoint: '${ApiConstants.goalsEndpoint}/$goalId',
        body: {'isCompleted': true},
        includeAuth: true,
        fromJsonT: (data) => GoalModel.fromJson(data as Map<String, dynamic>),
      );

      if (response.success) {
        DebugUtils.logInfo(
          'Goal completed successfully',
          tag: 'GoalRepository.completeGoal',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to complete goal: ${response.message}',
          tag: 'GoalRepository.completeGoal',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error completing goal',
        tag: 'GoalRepository.completeGoal',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<GoalModel>(
        success: false,
        message: 'Failed to complete goal: ${e.toString()}',
      );
    }
  }

  /// Delete a goal
  Future<ApiResponseModel<dynamic>> deleteGoal(String goalId) async {
    try {
      DebugUtils.logInfo(
        'Deleting goal: $goalId',
        tag: 'GoalRepository.deleteGoal',
      );

      final response = await _apiService.delete<dynamic>(
        endpoint: '${ApiConstants.goalsEndpoint}/$goalId',
        includeAuth: true,
        fromJsonT: (data) => data,
      );

      if (response.success) {
        DebugUtils.logInfo(
          'Goal deleted successfully',
          tag: 'GoalRepository.deleteGoal',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to delete goal: ${response.message}',
          tag: 'GoalRepository.deleteGoal',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error deleting goal',
        tag: 'GoalRepository.deleteGoal',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<dynamic>(
        success: false,
        message: 'Failed to delete goal: ${e.toString()}',
      );
    }
  }
}

