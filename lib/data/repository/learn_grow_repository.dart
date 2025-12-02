import '../../core/const/api_constants.dart';
import '../../core/utils/debug_utils.dart';
import '../models/api_response_model.dart';
import '../models/audio/audio_model.dart';
import '../models/learn_and_grow/video_model.dart';
import '../models/learn_and_grow/article_model.dart';
import '../services/api_service.dart';

/// Learn & Grow Repository
/// Handles all learn & grow related API operations (audios, videos, articles)
class LearnGrowRepository {
  final ApiService _apiService;

  LearnGrowRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Get audios with pagination
  Future<ApiResponseModel<List<AudioModel>>> getAudios({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      DebugUtils.logInfo(
        'Starting to fetch audios (page: $page, limit: $limit)',
        tag: 'AudioRepository.getAudios',
      );

      final queryParameters = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiService.get<List<AudioModel>>(
        endpoint: ApiConstants.audiosEndpoint,
        queryParameters: queryParameters,
        includeAuth: true,
        fromJsonT: (data) {
          // API returns: { success, page, limit, total, data: [...] }
          // The ApiResponseModel.fromJson will pass the 'data' field to this function
          if (data is List) {
            return data
                .map((item) => AudioModel.fromJson(item as Map<String, dynamic>))
                .toList();
          }
          return <AudioModel>[];
        },
      );

      if (response.success && response.data != null) {
        DebugUtils.logInfo(
          'Audios fetched successfully. Total: ${response.data!.length}',
          tag: 'LearnGrowRepository.getAudios',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to fetch audios: ${response.message}',
          tag: 'LearnGrowRepository.getAudios',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error fetching audios',
        tag: 'AudioRepository.getAudios',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<List<AudioModel>>(
        success: false,
        message: 'Failed to fetch audios: ${e.toString()}',
      );
    }
  }

  /// Get videos with pagination
  Future<ApiResponseModel<List<VideoModel>>> getVideos({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      DebugUtils.logInfo(
        'Starting to fetch videos (page: $page, limit: $limit)',
        tag: 'LearnGrowRepository.getVideos',
      );

      final queryParameters = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiService.get<List<VideoModel>>(
        endpoint: ApiConstants.videosEndpoint,
        queryParameters: queryParameters,
        includeAuth: true,
        fromJsonT: (data) {
          // API returns: { success, page, limit, total, data: [...] }
          // The ApiResponseModel.fromJson will pass the 'data' field to this function
          if (data is List) {
            return data
                .map((item) => VideoModel.fromJson(item as Map<String, dynamic>))
                .toList();
          }
          return <VideoModel>[];
        },
      );

      if (response.success && response.data != null) {
        DebugUtils.logInfo(
          'Videos fetched successfully. Total: ${response.data!.length}',
          tag: 'LearnGrowRepository.getVideos',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to fetch videos: ${response.message}',
          tag: 'LearnGrowRepository.getVideos',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error fetching videos',
        tag: 'LearnGrowRepository.getVideos',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<List<VideoModel>>(
        success: false,
        message: 'Failed to fetch videos: ${e.toString()}',
      );
    }
  }

  /// Get articles with pagination
  Future<ApiResponseModel<List<ArticleModel>>> getArticles({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      DebugUtils.logInfo(
        'Starting to fetch articles (page: $page, limit: $limit)',
        tag: 'LearnGrowRepository.getArticles',
      );

      final queryParameters = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await _apiService.get<List<ArticleModel>>(
        endpoint: ApiConstants.articlesEndpoint,
        queryParameters: queryParameters,
        includeAuth: true,
        fromJsonT: (data) {
          // API returns: { success, page, limit, total, data: [...] }
          // The ApiResponseModel.fromJson will pass the 'data' field to this function
          if (data is List) {
            return data
                .map((item) => ArticleModel.fromJson(item as Map<String, dynamic>))
                .toList();
          }
          return <ArticleModel>[];
        },
      );

      if (response.success && response.data != null) {
        DebugUtils.logInfo(
          'Articles fetched successfully. Total: ${response.data!.length}',
          tag: 'LearnGrowRepository.getArticles',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to fetch articles: ${response.message}',
          tag: 'LearnGrowRepository.getArticles',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error fetching articles',
        tag: 'LearnGrowRepository.getArticles',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<List<ArticleModel>>(
        success: false,
        message: 'Failed to fetch articles: ${e.toString()}',
      );
    }
  }
}
