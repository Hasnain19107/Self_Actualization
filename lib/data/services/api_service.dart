import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/const/api_constants.dart';
import '../../core/const/pref_consts.dart';
import '../../core/utils/debug_utils.dart';
import '../services/shared_preference_services.dart';
import '../models/api_response_model.dart';

/// API Service
/// Generic service for handling HTTP requests (GET, POST, PUT, DELETE)
class ApiService {
  /// Get authorization token from shared preferences
  Future<String?> _getToken() async {
    final token = await PreferenceHelper.getString(PrefConstants.token);
    if (token != null) {
      DebugUtils.logTokenOperation('Token retrieved', token: token);
    } else {
      DebugUtils.logTokenOperation('No token found');
    }
    return token;
  }

  /// Get default headers
  Future<Map<String, String>> _getHeaders({
    bool includeAuth = false,
    Map<String, String>? additionalHeaders,
  }) async {
    final headers = <String, String>{
      ApiConstants.contentTypeHeader: ApiConstants.applicationJson,
    };

    if (includeAuth) {
      final token = await _getToken();
      if (token != null && token.isNotEmpty) {
        headers[ApiConstants.authorizationHeader] =
            '${ApiConstants.bearerPrefix} $token';
      }
    }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  /// Handle HTTP response
  ApiResponseModel<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJsonT,
    String url,
    String method,
  ) {
    try {
      dynamic jsonData;
      
      // Try to parse JSON
      if (response.body.isNotEmpty) {
        jsonData = json.decode(response.body);
      } else {
        jsonData = <String, dynamic>{};
      }

      // Log response with status code handling
      if (response.statusCode >= 200 && response.statusCode < 300) {
        DebugUtils.logApiResponse(
          statusCode: response.statusCode,
          url: url,
          body: jsonData,
        );
      } else {
        // Log as error response
        DebugUtils.logApiResponse(
          statusCode: response.statusCode,
          url: url,
          body: jsonData,
          error: 'HTTP ${response.statusCode}',
        );

        // Also log as HTTP error for better visibility
        DebugUtils.logHttpError(
          statusCode: response.statusCode,
          url: url,
          method: method,
          body: jsonData,
          errorMessage: 'HTTP ${response.statusCode} Error',
        );
      }

      final responseData = jsonData is Map<String, dynamic>
          ? jsonData
          : <String, dynamic>{};

      return ApiResponseModel<T>.fromJson(
        {
          ...responseData,
          'statusCode': response.statusCode,
        },
        fromJsonT,
      );
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error parsing response',
        tag: 'ApiService._handleResponse',
        error: e,
        stackTrace: stackTrace,
      );

      DebugUtils.logHttpError(
        statusCode: response.statusCode,
        url: url,
        method: method,
        body: response.body,
        errorMessage: 'Parse Error: ${e.toString()}',
      );

      return ApiResponseModel<T>(
        success: false,
        message: 'Failed to parse response: ${e.toString()}',
        statusCode: response.statusCode,
      );
    }
  }

  /// Handle HTTP errors
  ApiResponseModel<T> _handleError<T>(
    dynamic error,
    String url,
    String method, [
    StackTrace? stackTrace,
    int? statusCode,
  ]) {
    DebugUtils.logNetworkError(
      url: url,
      method: method,
      error: error,
      stackTrace: stackTrace,
      statusCode: statusCode,
    );

    String errorMessage = 'Network error occurred';
    if (error.toString().contains('TimeoutException')) {
      errorMessage = 'Request timeout. Please check your connection.';
    } else if (error.toString().contains('SocketException')) {
      errorMessage = 'No internet connection. Please check your network.';
    } else {
      errorMessage = error.toString();
    }

    return ApiResponseModel<T>(
      success: false,
      message: errorMessage,
    );
  }

  /// GET Request
  Future<ApiResponseModel<T>> get<T>({
    required String endpoint,
    Map<String, String>? queryParameters,
    bool includeAuth = false,
    T Function(dynamic)? fromJsonT,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      var uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

      if (queryParameters != null && queryParameters.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParameters);
      }

      final headers = await _getHeaders(
        includeAuth: includeAuth,
        additionalHeaders: additionalHeaders,
      );

      DebugUtils.logApiRequest(
        method: 'GET',
        url: uri.toString(),
        headers: headers,
      );

      final response = await http
          .get(uri, headers: headers)
          .timeout(ApiConstants.connectionTimeout);

      return _handleResponse<T>(response, fromJsonT, uri.toString(), 'GET');
    } catch (e, stackTrace) {
      return _handleError<T>(e, '${ApiConstants.baseUrl}$endpoint', 'GET', stackTrace);
    }
  }

  /// POST Request
  Future<ApiResponseModel<T>> post<T>({
    required String endpoint,
    Map<String, dynamic>? body,
    bool includeAuth = false,
    T Function(dynamic)? fromJsonT,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(
        includeAuth: includeAuth,
        additionalHeaders: additionalHeaders,
      );

      DebugUtils.logApiRequest(
        method: 'POST',
        url: uri.toString(),
        body: body,
        headers: headers,
      );

      final response = await http
          .post(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(ApiConstants.connectionTimeout);

      return _handleResponse<T>(response, fromJsonT, uri.toString(), 'POST');
    } catch (e, stackTrace) {
      return _handleError<T>(e, '${ApiConstants.baseUrl}$endpoint', 'POST', stackTrace);
    }
  }

  /// PUT Request
  Future<ApiResponseModel<T>> put<T>({
    required String endpoint,
    Map<String, dynamic>? body,
    bool includeAuth = true,
    T Function(dynamic)? fromJsonT,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(
        includeAuth: includeAuth,
        additionalHeaders: additionalHeaders,
      );

      DebugUtils.logApiRequest(
        method: 'PUT',
        url: uri.toString(),
        body: body,
        headers: headers,
      );

      final response = await http
          .put(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(ApiConstants.connectionTimeout);

      return _handleResponse<T>(response, fromJsonT, uri.toString(), 'PUT');
    } catch (e, stackTrace) {
      return _handleError<T>(e, '${ApiConstants.baseUrl}$endpoint', 'PUT', stackTrace);
    }
  }

  /// DELETE Request
  Future<ApiResponseModel<T>> delete<T>({
    required String endpoint,
    Map<String, dynamic>? body,
    bool includeAuth = true,
    T Function(dynamic)? fromJsonT,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(
        includeAuth: includeAuth,
        additionalHeaders: additionalHeaders,
      );

      DebugUtils.logApiRequest(
        method: 'DELETE',
        url: uri.toString(),
        body: body,
        headers: headers,
      );

      final response = await http
          .delete(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(ApiConstants.connectionTimeout);

      return _handleResponse<T>(response, fromJsonT, uri.toString(), 'DELETE');
    } catch (e, stackTrace) {
      return _handleError<T>(e, '${ApiConstants.baseUrl}$endpoint', 'DELETE', stackTrace);
    }
  }
}

