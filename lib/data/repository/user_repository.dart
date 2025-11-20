import '../../core/const/api_constants.dart';
import '../../core/const/pref_consts.dart';
import '../../core/utils/debug_utils.dart';
import '../models/api_response_model.dart';
import '../models/user/user_model.dart';
import '../models/user/register_request_model.dart';
import '../models/user/login_request_model.dart';
import '../services/api_service.dart';
import '../services/shared_preference_services.dart';

/// User Repository
/// Handles all user-related API operations
class UserRepository {
  final ApiService _apiService;

  UserRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Register a new user
  Future<ApiResponseModel<UserModel>> register(
    RegisterRequestModel request,
  ) async {
    try {
      DebugUtils.logInfo(
        'Starting user registration',
        tag: 'UserRepository.register',
      );

      final response = await _apiService.post<UserModel>(
        endpoint: ApiConstants.registerEndpoint,
        body: request.toJson(),
        includeAuth: false,
        fromJsonT: (data) => UserModel.fromJson(data as Map<String, dynamic>),
      );

      // Save token if registration is successful
      if (response.success && response.data?.token != null) {
        await PreferenceHelper.setString(
          PrefConstants.token,
          response.data!.token!,
        );

        // Save user ID if available
        if (response.data?.id.isNotEmpty == true) {
          await PreferenceHelper.setString(
            PrefConstants.userId,
            response.data!.id,
          );
        }

        DebugUtils.logInfo(
          'User registered successfully. Token and user ID saved.',
          tag: 'UserRepository.register',
        );
      } else {
        DebugUtils.logWarning(
          'Registration failed: ${response.message}',
          tag: 'UserRepository.register',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Registration error',
        tag: 'UserRepository.register',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<UserModel>(
        success: false,
        message: 'Registration failed: ${e.toString()}',
      );
    }
  }

  /// Login user
  Future<ApiResponseModel<UserModel>> login(LoginRequestModel request) async {
    try {
      DebugUtils.logInfo(
        'Starting user login',
        tag: 'UserRepository.login',
      );

      final response = await _apiService.post<UserModel>(
        endpoint: ApiConstants.loginEndpoint,
        body: request.toJson(),
        includeAuth: false,
        fromJsonT: (data) => UserModel.fromJson(data as Map<String, dynamic>),
      );

      // Save token if login is successful
      if (response.success && response.data?.token != null) {
        await PreferenceHelper.setString(
          PrefConstants.token,
          response.data!.token!,
        );

        // Save user ID if available
        if (response.data?.id.isNotEmpty == true) {
          await PreferenceHelper.setString(
            PrefConstants.userId,
            response.data!.id,
          );
        }

        DebugUtils.logInfo(
          'User logged in successfully. Token and user ID saved.',
          tag: 'UserRepository.login',
        );
      } else {
        DebugUtils.logWarning(
          'Login failed: ${response.message}',
          tag: 'UserRepository.login',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Login error',
        tag: 'UserRepository.login',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<UserModel>(
        success: false,
        message: 'Login failed: ${e.toString()}',
      );
    }
  }

  /// Get current user token
  Future<String?> getToken() async {
    return await PreferenceHelper.getString(PrefConstants.token);
  }

  /// Get current user ID
  Future<String?> getUserId() async {
    return await PreferenceHelper.getString(PrefConstants.userId);
  }

  /// Logout user (clear stored data)
  Future<void> logout() async {
    try {
      DebugUtils.logInfo(
        'Starting user logout',
        tag: 'UserRepository.logout',
      );

      await PreferenceHelper.removeData(PrefConstants.token);
      await PreferenceHelper.removeData(PrefConstants.userId);

      DebugUtils.logInfo(
        'User logged out successfully. Token and user ID removed.',
        tag: 'UserRepository.logout',
      );
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Logout error',
        tag: 'UserRepository.logout',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Forgot password - send reset link to email
  Future<ApiResponseModel<dynamic>> forgotPassword(String email) async {
    try {
      DebugUtils.logInfo(
        'Starting forgot password request',
        tag: 'UserRepository.forgotPassword',
      );

      final response = await _apiService.post<dynamic>(
        endpoint: ApiConstants.forgotPasswordEndpoint,
        body: {'email': email},
        includeAuth: false,
        fromJsonT: (data) => data,
      );

      if (response.success) {
        DebugUtils.logInfo(
          'Forgot password request sent successfully',
          tag: 'UserRepository.forgotPassword',
        );
      } else {
        DebugUtils.logWarning(
          'Forgot password failed: ${response.message}',
          tag: 'UserRepository.forgotPassword',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Forgot password error',
        tag: 'UserRepository.forgotPassword',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<dynamic>(
        success: false,
        message: 'Failed to send reset link: ${e.toString()}',
      );
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

