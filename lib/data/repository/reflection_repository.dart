import '../../core/const/api_constants.dart';
import '../../core/utils/debug_utils.dart';
import '../models/api_response_model.dart';
import '../models/reflection/reflection_request_model.dart';
import '../models/reflection/reflection_model.dart';
import '../services/api_service.dart';

/// Reflection Repository
/// Handles all reflection-related API operations
class ReflectionRepository {
  final ApiService _apiService;

  ReflectionRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Create a new reflection
  Future<ApiResponseModel<Map<String, dynamic>>> createReflection(
    ReflectionRequestModel request,
  ) async {
    try {
      DebugUtils.logInfo(
        'Starting to create reflection',
        tag: 'ReflectionRepository.createReflection',
      );

      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: ApiConstants.reflectionsEndpoint,
        body: request.toJson(),
        includeAuth: true,
        fromJsonT: (data) => data as Map<String, dynamic>,
      );

      if (response.success) {
        DebugUtils.logInfo(
          'Reflection created successfully',
          tag: 'ReflectionRepository.createReflection',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to create reflection: ${response.message}',
          tag: 'ReflectionRepository.createReflection',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error creating reflection',
        tag: 'ReflectionRepository.createReflection',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<Map<String, dynamic>>(
        success: false,
        message: 'Failed to create reflection: ${e.toString()}',
      );
    }
  }

  /// Get reflections with date range
  Future<ApiResponseModel<List<ReflectionModel>>> getReflections({
    String? startDate,
    String? endDate,
  }) async {
    try {
      DebugUtils.logInfo(
        'Starting to fetch reflections',
        tag: 'ReflectionRepository.getReflections',
      );

      // Build query parameters
      final Map<String, String> queryParams = {};
      if (startDate != null && startDate.isNotEmpty) {
        queryParams['start'] = startDate;
      }
      if (endDate != null && endDate.isNotEmpty) {
        queryParams['end'] = endDate;
      }

      final response = await _apiService.get<List<ReflectionModel>>(
        endpoint: ApiConstants.reflectionsEndpoint,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
        includeAuth: true,
        fromJsonT: (data) {
          // The API returns { success, total, data: [...] }
          // The 'data' field is already extracted by ApiResponseModel
          // So 'data' parameter here is the list of reflections
          if (data is List) {
            return data
                .map((item) => ReflectionModel.fromJson(
                    item as Map<String, dynamic>))
                .toList();
          }
          return <ReflectionModel>[];
        },
      );

      if (response.success && response.data != null) {
        DebugUtils.logInfo(
          'Reflections fetched successfully. Total: ${response.data!.length}',
          tag: 'ReflectionRepository.getReflections',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to fetch reflections: ${response.message}',
          tag: 'ReflectionRepository.getReflections',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error fetching reflections',
        tag: 'ReflectionRepository.getReflections',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<List<ReflectionModel>>(
        success: false,
        message: 'Failed to fetch reflections: ${e.toString()}',
      );
    }
  }
}

