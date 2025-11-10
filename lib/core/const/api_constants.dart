/// API Constants
/// Contains all API-related constants including base URL and endpoints
class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://self-actualization-analysis.vercel.app';

  // API Endpoints
  static const String registerEndpoint = '/api/auth/register';
  static const String loginEndpoint = '/api/auth/login';

  // Headers
  static const String authorizationHeader = 'Authorization';
  static const String contentTypeHeader = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String bearerPrefix = 'Bearer';

  // Timeout durations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

