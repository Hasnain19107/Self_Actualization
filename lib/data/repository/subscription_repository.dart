import '../../core/const/api_constants.dart';
import '../../core/utils/debug_utils.dart';
import '../models/api_response_model.dart';
import '../models/subscription/subscription_response_model.dart';
import '../models/subscription/create_subscription_request_model.dart';
import '../services/api_service.dart';

/// Subscription Repository
/// Handles all subscription-related API operations
class SubscriptionRepository {
  final ApiService _apiService;

  SubscriptionRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Create subscription (after Stripe payment)
  Future<ApiResponseModel<SubscriptionResponseModel>> createSubscription(
    CreateSubscriptionRequestModel request,
  ) async {
    try {
      DebugUtils.logInfo(
        'Starting to create subscription: ${request.subscriptionType}',
        tag: 'SubscriptionRepository.createSubscription',
      );

      final response = await _apiService.post<SubscriptionResponseModel>(
        endpoint: ApiConstants.subscriptionCreateEndpoint,
        body: request.toJson(),
        includeAuth: true,
        fromJsonT: (data) {
          if (data is Map<String, dynamic>) {
            return SubscriptionResponseModel.fromJson(data);
          }
          throw Exception('Invalid subscription response format');
        },
      );

      if (response.success && response.data != null) {
        DebugUtils.logInfo(
          'Subscription created successfully',
          tag: 'SubscriptionRepository.createSubscription',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to create subscription: ${response.message}',
          tag: 'SubscriptionRepository.createSubscription',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error creating subscription',
        tag: 'SubscriptionRepository.createSubscription',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<SubscriptionResponseModel>(
        success: false,
        message: 'Failed to create subscription: ${e.toString()}',
      );
    }
  }

  /// Get current subscription
  Future<ApiResponseModel<SubscriptionResponseModel>> getCurrentSubscription() async {
    try {
      DebugUtils.logInfo(
        'Starting to fetch current subscription',
        tag: 'SubscriptionRepository.getCurrentSubscription',
      );

      final response = await _apiService.get<SubscriptionResponseModel>(
        endpoint: ApiConstants.subscriptionCurrentEndpoint,
        includeAuth: true,
        fromJsonT: (data) {
          if (data is Map<String, dynamic>) {
            return SubscriptionResponseModel.fromJson(data);
          }
          throw Exception('Invalid subscription response format');
        },
      );

      if (response.success && response.data != null) {
        DebugUtils.logInfo(
          'Current subscription fetched successfully',
          tag: 'SubscriptionRepository.getCurrentSubscription',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to fetch current subscription: ${response.message}',
          tag: 'SubscriptionRepository.getCurrentSubscription',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error fetching current subscription',
        tag: 'SubscriptionRepository.getCurrentSubscription',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<SubscriptionResponseModel>(
        success: false,
        message: 'Failed to fetch current subscription: ${e.toString()}',
      );
    }
  }

  /// Get available categories for a subscription type
  Future<ApiResponseModel<SubscriptionResponseModel>> getAvailableCategories(
    String subscriptionType,
  ) async {
    try {
      DebugUtils.logInfo(
        'Starting to fetch available categories for: $subscriptionType',
        tag: 'SubscriptionRepository.getAvailableCategories',
      );

      final response = await _apiService.get<SubscriptionResponseModel>(
        endpoint: ApiConstants.subscriptionAvailableCategoriesEndpoint,
        queryParameters: {'subscriptionType': subscriptionType},
        includeAuth: true,
        fromJsonT: (data) {
          if (data is Map<String, dynamic>) {
            return SubscriptionResponseModel.fromJson(data);
          }
          throw Exception('Invalid available categories response format');
        },
      );

      if (response.success && response.data != null) {
        DebugUtils.logInfo(
          'Available categories fetched successfully',
          tag: 'SubscriptionRepository.getAvailableCategories',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to fetch available categories: ${response.message}',
          tag: 'SubscriptionRepository.getAvailableCategories',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error fetching available categories',
        tag: 'SubscriptionRepository.getAvailableCategories',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<SubscriptionResponseModel>(
        success: false,
        message: 'Failed to fetch available categories: ${e.toString()}',
      );
    }
  }
}

