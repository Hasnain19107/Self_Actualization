import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../../core/const/app_exports.dart';
import '../../core/utils/debug_utils.dart';
import '../repository/notification_repository.dart';

/// FCM Service
/// Handles Firebase Cloud Messaging initialization, token management, and notification handling
class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final NotificationRepository _notificationRepository = NotificationRepository();
  
  String? _currentToken;
  StreamSubscription<String>? _tokenRefreshSubscription;

  /// Get current FCM token
  String? get currentToken => _currentToken;

  /// Initialize FCM service
  /// Should be called on app start
  Future<void> initialize() async {
    try {
      DebugUtils.logInfo(
        'Initializing FCM service',
        tag: 'FcmService.initialize',
      );

      // Request permission for notifications
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      DebugUtils.logInfo(
        'Notification permission status: ${settings.authorizationStatus}',
        tag: 'FcmService.initialize',
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        DebugUtils.logInfo(
          'User granted notification permission',
          tag: 'FcmService.initialize',
        );
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        DebugUtils.logInfo(
          'User granted provisional notification permission',
          tag: 'FcmService.initialize',
        );
      } else {
        DebugUtils.logWarning(
          'User denied notification permission',
          tag: 'FcmService.initialize',
        );
        return;
      }

      // Get FCM token
      await _getToken();

      // Listen for token refresh
      _tokenRefreshSubscription = _firebaseMessaging.onTokenRefresh.listen(
        (newToken) {
          DebugUtils.logInfo(
            'FCM token refreshed: $newToken',
            tag: 'FcmService.onTokenRefresh',
          );
          _currentToken = newToken;
          _saveTokenToBackend(newToken);
        },
        onError: (error) {
          DebugUtils.logError(
            'Error in token refresh',
            tag: 'FcmService.onTokenRefresh',
            error: error,
          );
        },
      );

      // Set up foreground message handler
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Set up background message handler (when app is in background)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

      // Check if app was opened from a terminated state via notification
      RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        DebugUtils.logInfo(
          'App opened from terminated state via notification',
          tag: 'FcmService.initialize',
        );
        _handleTerminatedMessage(initialMessage);
      }

      DebugUtils.logInfo(
        'FCM service initialized successfully',
        tag: 'FcmService.initialize',
      );
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error initializing FCM service',
        tag: 'FcmService.initialize',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get FCM token
  Future<void> _getToken() async {
    try {
      _currentToken = await _firebaseMessaging.getToken();
      if (_currentToken != null) {
        DebugUtils.logInfo(
          'FCM token retrieved: $_currentToken',
          tag: 'FcmService._getToken',
        );
        await _saveTokenToBackend(_currentToken!);
      } else {
        DebugUtils.logWarning(
          'FCM token is null',
          tag: 'FcmService._getToken',
        );
      }
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error getting FCM token',
        tag: 'FcmService._getToken',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Save FCM token to backend (public method for external calls)
  Future<void> saveTokenToBackend(String token) async {
    await _saveTokenToBackend(token);
  }

  /// Save FCM token to backend (private)
  Future<void> _saveTokenToBackend(String token) async {
    try {
      final response = await _notificationRepository.saveFcmToken(token);
      if (response.success) {
        DebugUtils.logInfo(
          'FCM token saved to backend successfully',
          tag: 'FcmService._saveTokenToBackend',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to save FCM token to backend: ${response.message}',
          tag: 'FcmService._saveTokenToBackend',
        );
      }
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error saving FCM token to backend',
        tag: 'FcmService._saveTokenToBackend',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Handle foreground message (when app is open)
  void _handleForegroundMessage(RemoteMessage message) {
    DebugUtils.logInfo(
      'Foreground notification received: ${message.notification?.title}',
      tag: 'FcmService._handleForegroundMessage',
    );

    // Show in-app notification UI
    if (message.notification != null) {
      Get.snackbar(
        message.notification!.title ?? 'Notification',
        message.notification!.body ?? '',
        colorText: AppColors.black,
        backgroundColor: AppColors.white,
        borderColor: AppColors.grey,
        borderRadius: 10,
        borderWidth: 1,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        icon: Icon(Icons.notifications, color: AppColors.blue),
        mainButton: TextButton(
          onPressed: () {
            Get.toNamed(AppRoutes.notificationScreen);
          },
          child: const Text('View'),
        ),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );
    }

    // Handle navigation
    _handleNotificationNavigation(message);
  }

  /// Handle background message (when app is in background)
  void _handleBackgroundMessage(RemoteMessage message) {
    DebugUtils.logInfo(
      'Background notification tapped: ${message.notification?.title}',
      tag: 'FcmService._handleBackgroundMessage',
    );

    // Navigate based on notification data
    _handleNotificationNavigation(message);
  }

  /// Handle terminated message (when app was closed and opened via notification)
  void _handleTerminatedMessage(RemoteMessage message) {
    DebugUtils.logInfo(
      'Terminated notification opened app: ${message.notification?.title}',
      tag: 'FcmService._handleTerminatedMessage',
    );

    // Small delay to ensure app is fully initialized
    Future.delayed(const Duration(milliseconds: 500), () {
      _handleNotificationNavigation(message);
    });
  }

  /// Handle notification navigation based on data.type
  void _handleNotificationNavigation(RemoteMessage message) {
    final data = message.data;
    final type = data['type'] as String?;
    final screen = data['screen'] as String?;
    final goalId = data['goalId'] as String?;

    DebugUtils.logInfo(
      'Handling notification navigation - type: $type, screen: $screen, goalId: $goalId',
      tag: 'FcmService._handleNotificationNavigation',
    );

    if (type == null) {
      DebugUtils.logWarning(
        'Notification has no type, skipping navigation',
        tag: 'FcmService._handleNotificationNavigation',
      );
      return;
    }

    // Navigate based on notification type
    switch (type) {
      case 'goal_completed':
      case 'goal_reminder':
        // Navigate to goals screen
        if (Get.currentRoute != AppRoutes.goalScreen) {
          Get.toNamed(AppRoutes.goalScreen);
        }
        break;

      case 'assessment_reminder':
        // Navigate to assessment screen
        if (Get.currentRoute != AppRoutes.selfAssessmentScreen) {
          Get.toNamed(AppRoutes.selfAssessmentScreen);
        }
        break;

      default:
        // Use screen hint if provided
        if (screen != null && screen.isNotEmpty) {
          try {
            // Map screen string to route
            if (screen == '/goals' || screen == '/goalScreen') {
              Get.toNamed(AppRoutes.goalScreen);
            } else if (screen == '/assessment' || screen == '/selfAssessmentScreen') {
              Get.toNamed(AppRoutes.selfAssessmentScreen);
            } else if (screen == '/home' || screen == '/homeScreen') {
              Get.toNamed(AppRoutes.homeScreen);
            }
          } catch (e) {
            DebugUtils.logError(
              'Error navigating to screen: $screen',
              tag: 'FcmService._handleNotificationNavigation',
              error: e,
            );
          }
        }
        break;
    }
  }

  /// Remove FCM token (call on logout)
  Future<void> removeToken() async {
    try {
      if (_currentToken != null) {
        DebugUtils.logInfo(
          'Removing FCM token: $_currentToken',
          tag: 'FcmService.removeToken',
        );

        final response = await _notificationRepository.removeFcmToken(_currentToken!);
        if (response.success) {
          DebugUtils.logInfo(
            'FCM token removed from backend successfully',
            tag: 'FcmService.removeToken',
          );
        } else {
          DebugUtils.logWarning(
            'Failed to remove FCM token from backend: ${response.message}',
            tag: 'FcmService.removeToken',
          );
        }

        _currentToken = null;
      }
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error removing FCM token',
        tag: 'FcmService.removeToken',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Dispose resources
  void dispose() {
    _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
  }
}

/// Top-level function for handling background messages
/// Must be a top-level function (not a class method)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  DebugUtils.logInfo(
    'Background message received: ${message.notification?.title}',
    tag: 'firebaseMessagingBackgroundHandler',
  );
  // Background messages are handled when app is opened
  // No need to do anything here unless you want to process data
}


