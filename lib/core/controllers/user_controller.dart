import 'package:get/get.dart';
import '../../data/models/user/user_model.dart';
import '../../data/repository/user_repository.dart';
import '../const/app_exports.dart';

/// User Controller
/// Manages global user state across the app - fetches once and reuses
class UserController extends GetxController {
  final UserRepository _userRepository = UserRepository();

  // User data
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoadingUser = false.obs;
  bool _hasFetched = false;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  /// Fetch current user data from API (only once)
  Future<void> fetchUserData() async {
    // Don't fetch if already fetched or currently loading
    if (_hasFetched || isLoadingUser.value) return;

    try {
      isLoadingUser.value = true;
      final response = await _userRepository.getUserData();

      if (response.success && response.data != null) {
        currentUser.value = response.data;
        _hasFetched = true;
      } else {
        DebugUtils.logWarning(
          'Failed to fetch user data: ${response.message}',
          tag: 'UserController.fetchUserData',
        );
      }
    } catch (e) {
      DebugUtils.logError(
        'Error fetching user data',
        tag: 'UserController.fetchUserData',
        error: e,
      );
    } finally {
      isLoadingUser.value = false;
    }
  }

  /// Get user name
  String get userName => currentUser.value?.name ?? '';

  /// Get user avatar path
  String? get userAvatar => currentUser.value?.avatar;

  /// Get user age
  int? get userAge => currentUser.value?.age;

  /// Get user focus areas
  List<String> get userFocusAreas => currentUser.value?.focusAreas ?? [];

  /// Refresh user data (force refetch)
  Future<void> refreshUserData() async {
    _hasFetched = false;
    await fetchUserData();
  }
}

