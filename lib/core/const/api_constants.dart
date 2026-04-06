import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// API Constants
/// Contains all API-related constants including base URL and endpoints
class ApiConstants {
  static const int _localPort = 5005;

  /// Optional override for local/dev (e.g. physical device):
  /// `flutter run --dart-define=API_BASE=http://192.168.1.10:5005`
  static const String _apiBaseOverride = String.fromEnvironment('API_BASE');

  /// Ngrok public URL (no trailing slash). Example: `https://abc123.ngrok-free.app`
  /// `flutter run --dart-define=NGROK_URL=https://abc123.ngrok-free.app`
  static const String _ngrokUrlFromEnv = String.fromEnvironment('NGROK_URL');

  /// Paste your current `ngrok http 5005` HTTPS URL here for simulator/dev (no trailing slash).
  /// When non-empty, this wins over localhost / 10.0.2.2 unless [API_BASE] or [NGROK_URL] is set via dart-define.
  static const String devNgrokBaseUrl = '';

  /// Production API host (same as backend deployment).
  static const String baseUrlProduction = 'http://3.26.225.122:5005';

  static String _trimTrailingSlash(String url) {
    if (url.isEmpty) return url;
    return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  /// Ngrok free tier may close connections or return an interstitial unless this header is sent.
  static bool get useNgrokTunnel =>
      baseUrl.toLowerCase().contains('ngrok');

  /// API base URL. Prefers ngrok when configured (handy for iOS Simulator + tunneled backend).
  /// Order: `API_BASE` → `NGROK_URL` → [devNgrokBaseUrl] → local loopback.
  static String get baseUrl {
    if (_apiBaseOverride.isNotEmpty) {
      return _trimTrailingSlash(_apiBaseOverride);
    }
    if (_ngrokUrlFromEnv.isNotEmpty) {
      return _trimTrailingSlash(_ngrokUrlFromEnv);
    }
    if (devNgrokBaseUrl.isNotEmpty) {
      return _trimTrailingSlash(devNgrokBaseUrl);
    }
    if (kIsWeb) {
      return 'http://localhost:$_localPort';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:$_localPort';
    }
    return 'http://127.0.0.1:$_localPort';
  }

  // API Endpoints
  static const String registerEndpoint = '/api/auth/register';
  static const String loginEndpoint = '/api/auth/login';
  /// Backend sync after Firebase (Google / Apple): `POST` body matches [oauthCallback] on the API.
  static const String oauthEndpoint = '/api/auth/oauth';
  static const String forgotPasswordEndpoint = '/api/auth/forgot-password';
  static const String getUserDataEndpoint = '/api/auth/me';
  static const String questionsEndpoint = '/api/questions';
  static const String assessmentSubmitEndpoint = '/api/assessment/submit';
  static const String assessmentResultEndpoint = '/api/assessment/result';
  static const String assessmentNeedsReportEndpoint = '/api/assessment/needs-report';
  static const String assessmentRecommendationsEndpoint = '/api/assessment/recommendations';
  static const String assessmentDownloadPdfEndpoint =
      '/api/assessment/download-pdf';
  static const String reflectionsEndpoint = '/api/reflections';
  static const String goalsEndpoint = '/api/goals';
  static const String goalsNeedsEndpoint = '/api/goals/needs';
  static const String profileEndpoint = '/api/auth/profile';
  static const String deleteAccountEndpoint = '/api/auth/delete-account';
  static const String avatarUploadEndpoint = '/api/auth/profile/avatar';
  static const String audiosEndpoint = '/api/audios';
  static const String videosEndpoint = '/api/videos';
  static const String articlesEndpoint = '/api/articles';
  static const String achievementsEndpoint = '/api/achievements';
  
  // Question Learning Content Endpoints
  static const String questionLearningEndpoint = '/api/question-learning';
  static const String questionLearningByQuestionEndpoint = '/api/question-learning/question';
  
  // Subscription Endpoints
  static const String subscriptionCreateEndpoint = '/api/subscriptions';
  static const String subscriptionCurrentEndpoint = '/api/subscriptions/current';
  static const String subscriptionAvailableCategoriesEndpoint = '/api/subscriptions/available-categories';

  // Notification Endpoints
  static const String notificationsEndpoint = '/api/notifications';
  static const String notificationFcmTokenEndpoint = '/api/notifications/fcm-token';
  static const String notificationTestEndpoint = '/api/notifications/test';
  static const String notificationReadAllEndpoint = '/api/notifications/read-all';

  // Headers
  static const String authorizationHeader = 'Authorization';
  static const String contentTypeHeader = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String bearerPrefix = 'Bearer';

  // Timeout durations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

