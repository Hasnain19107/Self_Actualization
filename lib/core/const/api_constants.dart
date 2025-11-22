/// API Constants
/// Contains all API-related constants including base URL and endpoints
class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://self-actualization-analysis-two.vercel.app';

  // API Endpoints
  static const String registerEndpoint = '/api/auth/register';
  static const String loginEndpoint = '/api/auth/login';
  static const String forgotPasswordEndpoint = '/api/auth/forgot-password';
  static const String questionsEndpoint = '/api/questions';
  static const String assessmentSubmitEndpoint = '/api/assessment/submit';
  static const String assessmentResultEndpoint = '/api/assessment/result';
  static const String reflectionsEndpoint = '/api/reflections';
  static const String goalsEndpoint = '/api/goals';

  // Headers
  static const String authorizationHeader = 'Authorization';
  static const String contentTypeHeader = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String bearerPrefix = 'Bearer';

  // Timeout durations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

