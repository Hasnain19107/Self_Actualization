import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/const/api_constants.dart';
import '../../core/const/pref_consts.dart';
import '../../core/utils/debug_utils.dart';
import '../models/api_response_model.dart';
import '../models/goal/goal_model.dart';
import '../models/goal/goal_request_model.dart';
import '../models/goal/goal_need_model.dart';
import '../services/api_service.dart';
import '../services/shared_preference_services.dart';

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

      final response = await _apiService.patch<GoalModel>(
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

  /// Get needs by category
  Future<ApiResponseModel<GoalNeedsResponseModel>> getNeedsByCategory(
    String category,
  ) async {
    try {
      DebugUtils.logInfo(
        'Fetching needs for category: $category',
        tag: 'GoalRepository.getNeedsByCategory',
      );

      // This API returns the response directly (not wrapped in ApiResponseModel format)
      // The response body is: {"success":true,"category":"Safety","total":5,"data":[...]}
      // ApiService.get() will try to extract json['data'] which is a List, causing a type error
      // So we need to make a direct HTTP call to parse the entire response body correctly
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.goalsNeedsEndpoint}/$category');
      final token = await PreferenceHelper.getString(PrefConstants.token);
      final headers = <String, String>{
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };
      
      DebugUtils.logApiRequest(
        method: 'GET',
        url: uri.toString(),
        headers: headers,
      );
      
      final httpResponse = await http.get(uri, headers: headers)
          .timeout(ApiConstants.connectionTimeout);
      
      if (httpResponse.statusCode == 200) {
        final jsonData = json.decode(httpResponse.body) as Map<String, dynamic>;
        final needsResponse = GoalNeedsResponseModel.fromJson(jsonData);
        
        DebugUtils.logInfo(
          'Needs fetched successfully. Total: ${needsResponse.total}',
          tag: 'GoalRepository.getNeedsByCategory',
        );

        return ApiResponseModel<GoalNeedsResponseModel>(
          success: true,
          message: '',
          data: needsResponse,
          statusCode: httpResponse.statusCode,
        );
      } else {
        DebugUtils.logHttpError(
          statusCode: httpResponse.statusCode,
          url: uri.toString(),
          method: 'GET',
          body: httpResponse.body,
          errorMessage: 'HTTP ${httpResponse.statusCode} Error',
        );
        
        return ApiResponseModel<GoalNeedsResponseModel>(
          success: false,
          message: 'Failed to fetch needs: HTTP ${httpResponse.statusCode}',
          statusCode: httpResponse.statusCode,
        );
      }
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error fetching needs',
        tag: 'GoalRepository.getNeedsByCategory',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<GoalNeedsResponseModel>(
        success: false,
        message: 'Failed to fetch needs: ${e.toString()}',
      );
    }
  }
  
}

