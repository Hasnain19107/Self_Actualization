import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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
      // Handle redirect responses (3xx status codes)
      if (response.statusCode >= 300 && response.statusCode < 400) {
        DebugUtils.logHttpError(
          statusCode: response.statusCode,
          url: url,
          method: method,
          body: response.body,
          errorMessage: 'Redirect response (${response.statusCode}). Please use HTTPS.',
        );
        
        return ApiResponseModel<T>(
          success: false,
          message: 'Redirect detected. Please check the API URL configuration.',
          statusCode: response.statusCode,
        );
      }

      dynamic jsonData;
      
      // Try to parse JSON
      if (response.body.isNotEmpty) {
        // Check if response body is valid JSON before parsing
        final trimmedBody = response.body.trim();
        if (trimmedBody.isEmpty || 
            (!trimmedBody.startsWith('{') && !trimmedBody.startsWith('['))) {
          // Not valid JSON, return error
          DebugUtils.logHttpError(
            statusCode: response.statusCode,
            url: url,
            method: method,
            body: response.body,
            errorMessage: 'Invalid JSON response',
          );
          
          return ApiResponseModel<T>(
            success: false,
            message: 'Invalid response format from server',
            statusCode: response.statusCode,
          );
        }
        
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

  /// PATCH Request
  Future<ApiResponseModel<T>> patch<T>({
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
        method: 'PATCH',
        url: uri.toString(),
        body: body,
        headers: headers,
      );

      final response = await http
          .patch(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(ApiConstants.connectionTimeout);

      return _handleResponse<T>(response, fromJsonT, uri.toString(), 'PATCH');
    } catch (e, stackTrace) {
      return _handleError<T>(e, '${ApiConstants.baseUrl}$endpoint', 'PATCH', stackTrace);
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

  /// Download binary file (e.g., PDF)
  Future<ApiResponseModel<Uint8List>> downloadFile({
    required String endpoint,
    bool includeAuth = true,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(
        includeAuth: includeAuth,
        additionalHeaders: additionalHeaders,
      );
      headers.putIfAbsent(HttpHeaders.acceptHeader, () => 'application/pdf');

      DebugUtils.logApiRequest(
        method: 'GET',
        url: uri.toString(),
        headers: headers,
      );

      final response = await http
          .get(uri, headers: headers)
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        DebugUtils.logApiResponse(
          statusCode: response.statusCode,
          url: uri.toString(),
          body: 'Binary file downloaded (${response.bodyBytes.lengthInBytes} bytes)',
        );

        return ApiResponseModel<Uint8List>(
          success: true,
          data: response.bodyBytes,
          message: '',
          statusCode: response.statusCode,
        );
      }

      DebugUtils.logHttpError(
        statusCode: response.statusCode,
        url: uri.toString(),
        method: 'GET',
        body: response.body,
        errorMessage: 'HTTP ${response.statusCode} Error',
      );

      return ApiResponseModel<Uint8List>(
        success: false,
        message: response.body.isNotEmpty
            ? response.body
            : 'Failed to download file (HTTP ${response.statusCode})',
        statusCode: response.statusCode,
      );
    } catch (e, stackTrace) {
      return _handleError<Uint8List>(
        e,
        '${ApiConstants.baseUrl}$endpoint',
        'GET',
        stackTrace,
      );
    }
  }

  /// Upload file using multipart/form-data
  Future<ApiResponseModel<T>> uploadFile<T>({
    required String endpoint,
    required File file,
    required String fieldName,
    bool includeAuth = true,
    T Function(dynamic)? fromJsonT,
    Map<String, String>? additionalFields,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      
      final request = http.MultipartRequest('POST', uri);
      
      // Add authorization header if needed
      if (includeAuth) {
        final token = await _getToken();
        if (token != null && token.isNotEmpty) {
          request.headers[ApiConstants.authorizationHeader] =
              '${ApiConstants.bearerPrefix} $token';
        }
      }
      
      // Add file with proper content type
      final fileStream = http.ByteStream(file.openRead());
      final fileLength = await file.length();
      final fileName = file.path.split('/').last.split('\\').last;
      final fileExtension = fileName.split('.').last.toLowerCase();
      
      // Determine MIME type based on file extension
      MediaType? contentType;
      switch (fileExtension) {
        case 'jpg':
        case 'jpeg':
          contentType = MediaType('image', 'jpeg');
          break;
        case 'png':
          contentType = MediaType('image', 'png');
          break;
        case 'gif':
          contentType = MediaType('image', 'gif');
          break;
        case 'webp':
          contentType = MediaType('image', 'webp');
          break;
        default:
          // Default to jpeg for unknown image types
          contentType = MediaType('image', 'jpeg');
      }
      
      final multipartFile = http.MultipartFile(
        fieldName,
        fileStream,
        fileLength,
        filename: fileName,
        contentType: contentType,
      );
      request.files.add(multipartFile);
      
      // Add additional fields if any
      if (additionalFields != null) {
        request.fields.addAll(additionalFields);
      }
      
      DebugUtils.logApiRequest(
        method: 'POST (Multipart)',
        url: uri.toString(),
        headers: request.headers,
        body: {'file': file.path, ...?additionalFields},
      );
      
      final streamedResponse = await request.send()
          .timeout(ApiConstants.connectionTimeout);
      final response = await http.Response.fromStream(streamedResponse);
      
      return _handleResponse<T>(response, fromJsonT, uri.toString(), 'POST (Multipart)');
    } catch (e, stackTrace) {
      return _handleError<T>(e, '${ApiConstants.baseUrl}$endpoint', 'POST (Multipart)', stackTrace);
    }
  }
}

