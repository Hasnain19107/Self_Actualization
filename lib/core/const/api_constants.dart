/// API Constants
/// Contains all API-related constants including base URL and endpoints
class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://3.26.225.122:5005';

  // API Endpoints
  static const String registerEndpoint = '/api/auth/register';
  static const String loginEndpoint = '/api/auth/login';
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
  static const String notificationFcmTokenEndpoint = '/api/notifications/fcm-token';
  static const String notificationTestEndpoint = '/api/notifications/test';

  // Headers
  static const String authorizationHeader = 'Authorization';
  static const String contentTypeHeader = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String bearerPrefix = 'Bearer';

  // Timeout durations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

