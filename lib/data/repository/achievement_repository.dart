import '../../core/const/api_constants.dart';
import '../../core/utils/debug_utils.dart';
import '../models/api_response_model.dart';
import '../models/achievement/achievement_model.dart';
import '../services/api_service.dart';

/// Achievement Repository
/// Handles achievement related API operations
class AchievementRepository {
  final ApiService _apiService;

  AchievementRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Get achievements data
  Future<ApiResponseModel<AchievementModel>> getAchievements() async {
    try {
      DebugUtils.logInfo(
        'Fetching achievements',
        tag: 'AchievementRepository.getAchievements',
      );

      final response = await _apiService.get<AchievementModel>(
        endpoint: ApiConstants.achievementsEndpoint,
        includeAuth: true,
        fromJsonT: (data) {
          // ApiResponseModel.fromJson extracts the 'data' field and passes it here
          // So 'data' is already the achievement object: { totalPoints: 4035, currentBadge: {...}, ... }
          if (data is Map<String, dynamic>) {
            return AchievementModel.fromJson(data);
          }
          throw Exception('Invalid data format');
        },
      );

      if (response.success && response.data != null) {
        DebugUtils.logInfo(
          'Achievements fetched successfully',
          tag: 'AchievementRepository.getAchievements',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to fetch achievements: ${response.message}',
          tag: 'AchievementRepository.getAchievements',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error fetching achievements',
        tag: 'AchievementRepository.getAchievements',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<AchievementModel>(
        success: false,
        message: 'Failed to fetch achievements: ${e.toString()}',
      );
    }
  }
}

