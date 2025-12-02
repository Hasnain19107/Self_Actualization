/// API Constants
/// Contains all API-related constants including base URL and endpoints
class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://self-actualization-analysis-be.vercel.app';

  // API Endpoints
  static const String registerEndpoint = '/api/auth/register';
  static const String loginEndpoint = '/api/auth/login';
  static const String forgotPasswordEndpoint = '/api/auth/forgot-password';
  static const String getUserDataEndpoint = '/api/auth/me';
  static const String questionsEndpoint = '/api/questions';
  static const String assessmentSubmitEndpoint = '/api/assessment/submit';
  static const String assessmentResultEndpoint = '/api/assessment/result';
  static const String assessmentDownloadPdfEndpoint =
      '/api/assessment/download-pdf';
  static const String reflectionsEndpoint = '/api/reflections';
  static const String goalsEndpoint = '/api/goals';
  static const String profileEndpoint = '/api/auth/profile';
  static const String audiosEndpoint = '/api/audios';
  static const String videosEndpoint = '/api/videos';
  static const String articlesEndpoint = '/api/articles';
  static const String achievementsEndpoint = '/api/achievements';
  
  // Subscription Endpoints
  static const String subscriptionCreateEndpoint = '/api/subscriptions';
  static const String subscriptionCurrentEndpoint = '/api/subscriptions/current';
  static const String subscriptionAvailableCategoriesEndpoint = '/api/subscriptions/available-categories';

  // Headers
  static const String authorizationHeader = 'Authorization';
  static const String contentTypeHeader = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String bearerPrefix = 'Bearer';

  // Timeout durations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

