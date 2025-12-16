import '../../core/const/api_constants.dart';
import '../../core/utils/debug_utils.dart';
import '../models/api_response_model.dart';
import '../services/api_service.dart';

/// Notification Repository
/// Handles FCM token management API operations
class NotificationRepository {
  final ApiService _apiService;

  NotificationRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Save/update FCM token
  /// Adds the token to user's fcmTokens array (deduped)
  Future<ApiResponseModel<Map<String, dynamic>>> saveFcmToken(
    String fcmToken,
  ) async {
    try {
      DebugUtils.logInfo(
        'Saving FCM token',
        tag: 'NotificationRepository.saveFcmToken',
      );

      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: ApiConstants.notificationFcmTokenEndpoint,
        body: {'fcmToken': fcmToken},
        includeAuth: true,
        fromJsonT: (data) => data as Map<String, dynamic>,
      );

      if (response.success) {
        DebugUtils.logInfo(
          'FCM token saved successfully',
          tag: 'NotificationRepository.saveFcmToken',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to save FCM token: ${response.message}',
          tag: 'NotificationRepository.saveFcmToken',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error saving FCM token',
        tag: 'NotificationRepository.saveFcmToken',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<Map<String, dynamic>>(
        success: false,
        message: 'Failed to save FCM token: ${e.toString()}',
      );
    }
  }

  /// Remove FCM token (on logout/uninstall)
  /// Removes this device token from user's fcmTokens array
  Future<ApiResponseModel<Map<String, dynamic>>> removeFcmToken(
    String fcmToken,
  ) async {
    try {
      DebugUtils.logInfo(
        'Removing FCM token',
        tag: 'NotificationRepository.removeFcmToken',
      );

      final response = await _apiService.delete<Map<String, dynamic>>(
        endpoint: ApiConstants.notificationFcmTokenEndpoint,
        body: {'fcmToken': fcmToken},
        includeAuth: true,
        fromJsonT: (data) => data as Map<String, dynamic>,
      );

      if (response.success) {
        DebugUtils.logInfo(
          'FCM token removed successfully',
          tag: 'NotificationRepository.removeFcmToken',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to remove FCM token: ${response.message}',
          tag: 'NotificationRepository.removeFcmToken',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error removing FCM token',
        tag: 'NotificationRepository.removeFcmToken',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<Map<String, dynamic>>(
        success: false,
        message: 'Failed to remove FCM token: ${e.toString()}',
      );
    }
  }

  /// Send test notification (for testing)
  /// Sends a test notification to all devices registered for the authenticated user
  Future<ApiResponseModel<Map<String, dynamic>>> sendTestNotification({
    String? title,
    String? body,
    String? type,
  }) async {
    try {
      DebugUtils.logInfo(
        'Sending test notification',
        tag: 'NotificationRepository.sendTestNotification',
      );

      final bodyData = <String, dynamic>{};
      if (title != null) bodyData['title'] = title;
      if (body != null) bodyData['body'] = body;
      if (type != null) bodyData['type'] = type;

      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: ApiConstants.notificationTestEndpoint,
        body: bodyData.isNotEmpty ? bodyData : null,
        includeAuth: true,
        fromJsonT: (data) => data as Map<String, dynamic>,
      );

      if (response.success) {
        DebugUtils.logInfo(
          'Test notification sent successfully',
          tag: 'NotificationRepository.sendTestNotification',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to send test notification: ${response.message}',
          tag: 'NotificationRepository.sendTestNotification',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error sending test notification',
        tag: 'NotificationRepository.sendTestNotification',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<Map<String, dynamic>>(
        success: false,
        message: 'Failed to send test notification: ${e.toString()}',
      );
    }
  }
}


