import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Debug Utils
/// Utility class for debugging and logging throughout the application
class DebugUtils {
  /// Check if app is in debug mode
  static bool get isDebugMode => kDebugMode;

  /// Log API Request
  static void logApiRequest({
    required String method,
    required String url,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) {
    if (!isDebugMode) return;

    developer.log(
      '''
═══════════════════════════════════════════════════════════
🚀 API REQUEST
═══════════════════════════════════════════════════════════
Method: $method
URL: $url
${headers != null ? 'Headers: $headers' : ''}
${body != null ? 'Body: ${_formatJson(body)}' : ''}
═══════════════════════════════════════════════════════════
''',
      name: 'API_REQUEST',
    );
  }

  /// Log API Response
  static void logApiResponse({
    required int statusCode,
    required String url,
    dynamic body,
    String? error,
  }) {
    if (!isDebugMode) return;

    // Determine if it's an error based on status code
    final isError = statusCode < 200 || statusCode >= 300 || error != null;
    final statusMessage = _getStatusMessage(statusCode);

    if (isError) {
      developer.log(
        '''
═══════════════════════════════════════════════════════════
❌ API ERROR RESPONSE
═══════════════════════════════════════════════════════════
URL: $url
Status Code: $statusCode ($statusMessage)
${error != null ? 'Error: $error' : ''}
${body != null ? 'Body: ${_formatJson(body)}' : 'Body: null'}
═══════════════════════════════════════════════════════════
''',
        name: 'API_ERROR',
        error: error ?? 'HTTP $statusCode',
      );
    } else {
      developer.log(
        '''
═══════════════════════════════════════════════════════════
✅ API SUCCESS RESPONSE
═══════════════════════════════════════════════════════════
URL: $url
Status Code: $statusCode ($statusMessage)
${body != null ? 'Body: ${_formatJson(body)}' : 'Body: null'}
═══════════════════════════════════════════════════════════
''',
        name: 'API_RESPONSE',
      );
    }
  }

  /// Get HTTP status code message
  static String _getStatusMessage(int statusCode) {
    switch (statusCode) {
      // 2xx Success
      case 200:
        return 'OK';
      case 201:
        return 'Created';
      case 202:
        return 'Accepted';
      case 204:
        return 'No Content';

      // 4xx Client Errors
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not Found';
      case 405:
        return 'Method Not Allowed';
      case 409:
        return 'Conflict';
      case 422:
        return 'Unprocessable Entity';
      case 429:
        return 'Too Many Requests';

      // 5xx Server Errors
      case 500:
        return 'Internal Server Error';
      case 501:
        return 'Not Implemented';
      case 502:
        return 'Bad Gateway';
      case 503:
        return 'Service Unavailable';
      case 504:
        return 'Gateway Timeout';

      default:
        if (statusCode >= 200 && statusCode < 300) {
          return 'Success';
        } else if (statusCode >= 400 && statusCode < 500) {
          return 'Client Error';
        } else if (statusCode >= 500) {
          return 'Server Error';
        } else {
          return 'Unknown';
        }
    }
  }

  /// Log General Info
  static void logInfo(String message, {String? tag}) {
    if (!isDebugMode) return;
    developer.log(
      message,
      name: tag ?? 'INFO',
    );
  }

  /// Log Warning
  static void logWarning(String message, {String? tag, dynamic error}) {
    if (!isDebugMode) return;
    developer.log(
      message,
      name: tag ?? 'WARNING',
      error: error,
    );
  }

  /// Log Error
  static void logError(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (!isDebugMode) return;
    developer.log(
      message,
      name: tag ?? 'ERROR',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log Debug Message
  static void logDebug(String message, {String? tag}) {
    if (!isDebugMode) return;
    developer.log(
      message,
      name: tag ?? 'DEBUG',
    );
  }

  /// Format JSON for logging
  static String _formatJson(dynamic json) {
    try {
      if (json is Map || json is List) {
        // Use a formatter to make JSON readable
        final encoder = JsonEncoder.withIndent('  ');
        return encoder.convert(json);
      }
      return json.toString();
    } catch (e) {
      return json.toString();
    }
  }

  /// Log Network Error
  static void logNetworkError({
    required String url,
    required String method,
    dynamic error,
    StackTrace? stackTrace,
    int? statusCode,
  }) {
    if (!isDebugMode) return;

    final statusInfo = statusCode != null
        ? 'Status Code: $statusCode (${_getStatusMessage(statusCode)})'
        : '';

    developer.log(
      '''
═══════════════════════════════════════════════════════════
🌐 NETWORK ERROR
═══════════════════════════════════════════════════════════
Method: $method
URL: $url
${statusInfo.isNotEmpty ? '$statusInfo\n' : ''}Error: ${error.toString()}
═══════════════════════════════════════════════════════════
''',
      name: 'NETWORK_ERROR',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log HTTP Error with Status Code
  static void logHttpError({
    required int statusCode,
    required String url,
    required String method,
    dynamic body,
    String? errorMessage,
  }) {
    if (!isDebugMode) return;

    final statusMessage = _getStatusMessage(statusCode);
    final errorType = _getErrorType(statusCode);

    developer.log(
      '''
═══════════════════════════════════════════════════════════
🚨 HTTP ERROR ($errorType)
═══════════════════════════════════════════════════════════
Method: $method
URL: $url
Status Code: $statusCode ($statusMessage)
${errorMessage != null ? 'Error Message: $errorMessage\n' : ''}${body != null ? 'Response Body: ${_formatJson(body)}' : 'Response Body: null'}
═══════════════════════════════════════════════════════════
''',
      name: 'HTTP_ERROR',
      error: errorMessage ?? 'HTTP $statusCode',
    );
  }

  /// Get error type based on status code
  static String _getErrorType(int statusCode) {
    if (statusCode >= 400 && statusCode < 500) {
      return 'CLIENT ERROR';
    } else if (statusCode >= 500) {
      return 'SERVER ERROR';
    } else {
      return 'HTTP ERROR';
    }
  }

  /// Log Token Operations
  static void logTokenOperation(String operation, {String? token}) {
    if (!isDebugMode) return;
    developer.log(
      '''
🔑 TOKEN OPERATION: $operation
${token != null ? 'Token: ${_maskToken(token)}' : 'Token: null'}
''',
      name: 'TOKEN',
    );
  }

  /// Mask sensitive token data
  static String _maskToken(String token) {
    if (token.length <= 10) return '***';
    return '${token.substring(0, 4)}...${token.substring(token.length - 4)}';
  }
}

