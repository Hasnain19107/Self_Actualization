import 'dart:io';
import '../../core/const/api_constants.dart';
import '../../core/const/pref_consts.dart';
import '../../core/utils/debug_utils.dart';
import '../models/api_response_model.dart';
import '../models/user/user_model.dart';
import '../models/user/register_request_model.dart';
import '../models/user/login_request_model.dart';
import '../models/user/profile_update_request_model.dart';
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
        fromJsonT: (data) {
          // Handle nested structure: data.user and data.token
          final dataMap = data as Map<String, dynamic>;
          final userData = dataMap.containsKey('user')
              ? dataMap['user'] as Map<String, dynamic>
              : dataMap;
          
          // Extract token from data.token and add it to user data
          final token = dataMap['token'] as String?;
          if (token != null) {
            userData['token'] = token;
          }
          
          return UserModel.fromJson(userData);
        },
      );

      // Save token if login is successful
      if (response.success && response.data != null) {
        final user = response.data!;
        
        // Save token if available
        if (user.token != null && user.token!.isNotEmpty) {
          await PreferenceHelper.setString(
            PrefConstants.token,
            user.token!,
          );
        }

        // Save user ID if available
        if (user.id.isNotEmpty) {
          await PreferenceHelper.setString(
            PrefConstants.userId,
            user.id,
          );
        }

        // Save subscription plan if available
        if (user.currentSubscriptionType != null && user.currentSubscriptionType!.isNotEmpty) {
          await PreferenceHelper.setString(
            PrefConstants.subscriptionPlan,
            user.currentSubscriptionType!,
          );
        }

        // Save assessment completion status
        await PreferenceHelper.setBool(
          PrefConstants.hasCompletedAssessment,
          user.hasCompletedAssessment ?? false,
        );

        DebugUtils.logInfo(
          'User logged in successfully. Token, user ID, subscription plan, and assessment status saved.',
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
      await PreferenceHelper.removeData(PrefConstants.subscriptionPlan);
      await PreferenceHelper.removeData(PrefConstants.hasCompletedAssessment);

      DebugUtils.logInfo(
        'User logged out successfully. Token, user ID, subscription plan, and assessment status removed.',
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

  /// Update user profile information
  Future<ApiResponseModel<Map<String, dynamic>>> updateProfile(
    ProfileUpdateRequestModel request,
  ) async {
    try {
      DebugUtils.logInfo(
        'Starting profile update request',
        tag: 'UserRepository.updateProfile',
      );

      final response = await _apiService.put<Map<String, dynamic>>(
        endpoint: ApiConstants.profileEndpoint,
        body: request.toJson(),
        includeAuth: true,
        fromJsonT: (data) => data as Map<String, dynamic>,
      );

      if (response.success) {
        DebugUtils.logInfo(
          'Profile updated successfully',
          tag: 'UserRepository.updateProfile',
        );
      } else {
        DebugUtils.logWarning(
          'Profile update failed: ${response.message}',
          tag: 'UserRepository.updateProfile',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Profile update error',
        tag: 'UserRepository.updateProfile',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<Map<String, dynamic>>(
        success: false,
        message: 'Failed to update profile: ${e.toString()}',
      );
    }
  }

  /// Get current user data
  Future<ApiResponseModel<UserModel>> getUserData() async {
    try {
      DebugUtils.logInfo(
        'Starting to fetch user data',
        tag: 'UserRepository.getUserData',
      );

      final response = await _apiService.get<UserModel>(
        endpoint: ApiConstants.getUserDataEndpoint,
        includeAuth: true, // Requires authentication
        fromJsonT: (data) {
          // The API returns { success, data: { user: {...} } }
          // So 'data' parameter here is the data object containing 'user'
          if (data is Map<String, dynamic>) {
            final userData = data['user'] as Map<String, dynamic>?;
            if (userData != null) {
              return UserModel.fromJson(userData);
            }
          }
          throw Exception('Invalid user data format');
        },
      );

      if (response.success && response.data != null) {
        DebugUtils.logInfo(
          'User data fetched successfully',
          tag: 'UserRepository.getUserData',
        );
      } else {
        DebugUtils.logWarning(
          'Failed to fetch user data: ${response.message}',
          tag: 'UserRepository.getUserData',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Error fetching user data',
        tag: 'UserRepository.getUserData',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<UserModel>(
        success: false,
        message: 'Failed to fetch user data: ${e.toString()}',
      );
    }
  }

  /// Upload user avatar image
  Future<ApiResponseModel<Map<String, dynamic>>> uploadAvatar(File imageFile) async {
    try {
      DebugUtils.logInfo(
        'Starting avatar upload',
        tag: 'UserRepository.uploadAvatar',
      );

      final response = await _apiService.uploadFile<Map<String, dynamic>>(
        endpoint: ApiConstants.avatarUploadEndpoint,
        file: imageFile,
        fieldName: 'avatar',
        includeAuth: true,
        fromJsonT: (data) => data as Map<String, dynamic>,
      );

      if (response.success) {
        DebugUtils.logInfo(
          'Avatar uploaded successfully',
          tag: 'UserRepository.uploadAvatar',
        );
      } else {
        DebugUtils.logWarning(
          'Avatar upload failed: ${response.message}',
          tag: 'UserRepository.uploadAvatar',
        );
      }

      return response;
    } catch (e, stackTrace) {
      DebugUtils.logError(
        'Avatar upload error',
        tag: 'UserRepository.uploadAvatar',
        error: e,
        stackTrace: stackTrace,
      );

      return ApiResponseModel<Map<String, dynamic>>(
        success: false,
        message: 'Failed to upload avatar: ${e.toString()}',
      );
    }
  }
}

