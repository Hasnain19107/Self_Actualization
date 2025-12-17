import '../../core/const/api_constants.dart';
import '../../core/utils/debug_utils.dart';
import '../models/api_response_model.dart';
import '../models/notification/notification_model.dart';
import '../services/api_service.dart';

/// Notification Repository
/// Handles all notification-related API operations
class NotificationRepository {
  final ApiService _apiService;

  NotificationRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Get all notifications with pagination and filters
  Future<ApiResponseModel<NotificationsResponse>> getNotifications({
    int page = 1,
    int limit = 20,
    String? type,
    bool? isRead,
  }) async {
    try {
      DebugUtils.logInfo(
        'Fetching notifications - page: $page, limit: $limit, type: $type, isRead: $isRead',
        tag: 'NotificationRepository.getNotifications',
      );

      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (type != null) {
        queryParams['type'] = type;
      }

      if (isRead != null) {
        queryParams['isRead'] = isRead.toString();
      }

      final response = await _apiService.get<NotificationsResponse>(
        endpoint: ApiConstants.notificationsEndpoint,
        queryParameters: queryParams,
        includeAuth: true,
        fromJsonT: (data) =>
            NotificationsResponse.fromJson(data as Map<String, dynamic>),
      );

      if (response.success) {
        DebugUtils.logInfo(
          'Notifications fetched successfully - count: ${response.data?.notifications.length ?? 0}',
          tag: 'NotificationRepository.getNotifications',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to fetch notifications: ${response.message}',
          tag: 'NotificationRepository.getNotifications',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error fetching notifications',
        tag: 'NotificationRepository.getNotifications',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<NotificationsResponse>(
        success: false,
        message: 'Failed to fetch notifications: ${e.toString()}',
      );
    }
  }

  /// Mark a single notification as read
  Future<ApiResponseModel<NotificationModel>> markAsRead(String id) async {
    try {
      DebugUtils.logInfo(
        'Marking notification as read - id: $id',
        tag: 'NotificationRepository.markAsRead',
      );

      final response = await _apiService.patch<NotificationModel>(
        endpoint: '${ApiConstants.notificationsEndpoint}/$id/read',
        includeAuth: true,
        fromJsonT: (data) {
          // Handle both direct notification and nested notification response
          if (data is Map<String, dynamic>) {
            if (data.containsKey('notification')) {
              return NotificationModel.fromJson(
                  data['notification'] as Map<String, dynamic>);
            }
            return NotificationModel.fromJson(data);
          }
          throw Exception('Invalid response format');
        },
      );

      if (response.success) {
        DebugUtils.logInfo(
          'Notification marked as read successfully',
          tag: 'NotificationRepository.markAsRead',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to mark notification as read: ${response.message}',
          tag: 'NotificationRepository.markAsRead',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error marking notification as read',
        tag: 'NotificationRepository.markAsRead',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<NotificationModel>(
        success: false,
        message: 'Failed to mark notification as read: ${e.toString()}',
      );
    }
  }

  /// Mark all notifications as read
  Future<ApiResponseModel<Map<String, dynamic>>> markAllAsRead() async {
    try {
      DebugUtils.logInfo(
        'Marking all notifications as read',
        tag: 'NotificationRepository.markAllAsRead',
      );

      final response = await _apiService.patch<Map<String, dynamic>>(
        endpoint: ApiConstants.notificationReadAllEndpoint,
        includeAuth: true,
        fromJsonT: (data) => data as Map<String, dynamic>,
      );

      if (response.success) {
        DebugUtils.logInfo(
          'All notifications marked as read - count: ${response.data?['updatedCount'] ?? 0}',
          tag: 'NotificationRepository.markAllAsRead',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to mark all notifications as read: ${response.message}',
          tag: 'NotificationRepository.markAllAsRead',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error marking all notifications as read',
        tag: 'NotificationRepository.markAllAsRead',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<Map<String, dynamic>>(
        success: false,
        message: 'Failed to mark all notifications as read: ${e.toString()}',
      );
    }
  }

  /// Delete a single notification
  Future<ApiResponseModel<Map<String, dynamic>>> deleteNotification(
      String id) async {
    try {
      DebugUtils.logInfo(
        'Deleting notification - id: $id',
        tag: 'NotificationRepository.deleteNotification',
      );

      final response = await _apiService.delete<Map<String, dynamic>>(
        endpoint: '${ApiConstants.notificationsEndpoint}/$id',
        includeAuth: true,
        fromJsonT: (data) => data as Map<String, dynamic>,
      );

      if (response.success) {
        DebugUtils.logInfo(
          'Notification deleted successfully',
          tag: 'NotificationRepository.deleteNotification',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to delete notification: ${response.message}',
          tag: 'NotificationRepository.deleteNotification',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error deleting notification',
        tag: 'NotificationRepository.deleteNotification',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<Map<String, dynamic>>(
        success: false,
        message: 'Failed to delete notification: ${e.toString()}',
      );
    }
  }

  /// Delete all notifications (optionally by type)
  Future<ApiResponseModel<Map<String, dynamic>>> deleteAllNotifications({
    String? type,
  }) async {
    try {
      DebugUtils.logInfo(
        'Deleting all notifications${type != null ? ' of type: $type' : ''}',
        tag: 'NotificationRepository.deleteAllNotifications',
      );

      String endpoint = ApiConstants.notificationsEndpoint;
      if (type != null) {
        endpoint = '$endpoint?type=$type';
      }

      final response = await _apiService.delete<Map<String, dynamic>>(
        endpoint: endpoint,
        includeAuth: true,
        fromJsonT: (data) => data as Map<String, dynamic>,
      );

      if (response.success) {
        DebugUtils.logInfo(
          'All notifications deleted - count: ${response.data?['deletedCount'] ?? 0}',
          tag: 'NotificationRepository.deleteAllNotifications',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to delete all notifications: ${response.message}',
          tag: 'NotificationRepository.deleteAllNotifications',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error deleting all notifications',
        tag: 'NotificationRepository.deleteAllNotifications',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<Map<String, dynamic>>(
        success: false,
        message: 'Failed to delete all notifications: ${e.toString()}',
      );
    }
  }

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
