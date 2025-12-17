import 'package:get/get.dart';
import '../../../core/widgets/custom_toast_show.dart';
import '../../../data/models/notification/notification_model.dart';
import '../../../data/repository/notification_repository.dart';

class NotificationController extends GetxController {
  final NotificationRepository _repository;

  NotificationController({NotificationRepository? repository})
      : _repository = repository ?? NotificationRepository();

  // State
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt unreadCount = 0.obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalNotifications = 0.obs;
  final int limit = 20;

  // Filter
  final Rx<String?> selectedType = Rx<String?>(null);
  final Rx<bool?> selectedIsRead = Rx<bool?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  /// Fetch notifications from API
  Future<void> fetchNotifications({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      notifications.clear();
    }

    if (currentPage.value == 1) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }
    hasError.value = false;
    errorMessage.value = '';

    try {
      final response = await _repository.getNotifications(
        page: currentPage.value,
        limit: limit,
        type: selectedType.value,
        isRead: selectedIsRead.value,
      );

      if (response.success && response.data != null) {
        if (refresh || currentPage.value == 1) {
          notifications.value = response.data!.notifications;
        } else {
          notifications.addAll(response.data!.notifications);
        }
        totalPages.value = response.data!.pagination.totalPages;
        totalNotifications.value = response.data!.pagination.total;
        unreadCount.value = response.data!.unreadCount;
      } else {
        hasError.value = true;
        errorMessage.value = response.message;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load notifications';
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  /// Load more notifications (pagination)
  Future<void> loadMore() async {
    if (isLoadingMore.value || currentPage.value >= totalPages.value) return;

    currentPage.value++;
    await fetchNotifications();
  }

  /// Refresh notifications
  Future<void> refresh() async {
    await fetchNotifications(refresh: true);
  }

  /// Mark a notification as read
  Future<void> markAsRead(String id) async {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index == -1) return;

    // Optimistic update
    final notification = notifications[index];
    if (notification.isRead) return; // Already read

    notifications[index] = notification.copyWith(
      isRead: true,
      readAt: DateTime.now(),
    );
    unreadCount.value = (unreadCount.value - 1).clamp(0, totalNotifications.value);

    final response = await _repository.markAsRead(id);

    if (!response.success) {
      // Rollback on failure
      notifications[index] = notification;
      unreadCount.value++;
      ToastClass.showCustomToast(response.message, type: ToastType.error);
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    if (unreadCount.value == 0) return;

    // Store current state for rollback
    final previousNotifications =
        notifications.map((n) => n.copyWith()).toList();
    final previousUnreadCount = unreadCount.value;

    // Optimistic update
    notifications.value = notifications
        .map((n) => n.copyWith(isRead: true, readAt: DateTime.now()))
        .toList();
    unreadCount.value = 0;

    final response = await _repository.markAllAsRead();

    if (response.success) {
      ToastClass.showCustomToast('All notifications marked as read', type: ToastType.success);
    } else {
      // Rollback on failure
      notifications.value = previousNotifications;
      unreadCount.value = previousUnreadCount;
      ToastClass.showCustomToast(response.message, type: ToastType.error);
    }
  }

  /// Delete a notification
  Future<void> deleteNotification(String id) async {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index == -1) return;

    // Store for rollback
    final notification = notifications[index];
    final wasUnread = !notification.isRead;

    // Optimistic update
    notifications.removeAt(index);
    totalNotifications.value--;
    if (wasUnread) {
      unreadCount.value = (unreadCount.value - 1).clamp(0, totalNotifications.value);
    }

    final response = await _repository.deleteNotification(id);

    if (response.success) {
      ToastClass.showCustomToast('Notification deleted', type: ToastType.success);
    } else {
      // Rollback on failure
      notifications.insert(index, notification);
      totalNotifications.value++;
      if (wasUnread) {
        unreadCount.value++;
      }
      ToastClass.showCustomToast(response.message, type: ToastType.error);
    }
  }

  /// Delete all notifications
  Future<void> deleteAllNotifications({String? type}) async {
    if (notifications.isEmpty) return;

    // Store for rollback
    final previousNotifications = List<NotificationModel>.from(notifications);
    final previousTotal = totalNotifications.value;
    final previousUnread = unreadCount.value;

    // Optimistic update
    if (type != null) {
      notifications.removeWhere((n) => n.type == type);
    } else {
      notifications.clear();
    }
    totalNotifications.value = notifications.length;
    unreadCount.value = notifications.where((n) => !n.isRead).length;

    final response = await _repository.deleteAllNotifications(type: type);

    if (response.success) {
      ToastClass.showCustomToast('All notifications deleted', type: ToastType.success);
    } else {
      // Rollback on failure
      notifications.value = previousNotifications;
      totalNotifications.value = previousTotal;
      unreadCount.value = previousUnread;
      ToastClass.showCustomToast(response.message, type: ToastType.error);
    }
  }

  /// Filter by type
  void filterByType(String? type) {
    selectedType.value = type;
    fetchNotifications(refresh: true);
  }

  /// Filter by read status
  void filterByReadStatus(bool? isRead) {
    selectedIsRead.value = isRead;
    fetchNotifications(refresh: true);
  }

  /// Clear all filters
  void clearFilters() {
    selectedType.value = null;
    selectedIsRead.value = null;
    fetchNotifications(refresh: true);
  }

  /// Check if there are more pages to load
  bool get hasMorePages => currentPage.value < totalPages.value;

  /// Check if the list is empty
  bool get isEmpty => notifications.isEmpty && !isLoading.value;

  /// Get notification type display text
  String getTypeDisplayText(String type) {
    switch (type) {
      case 'goal_completed':
        return 'Goal Completed';
      case 'goal_reminder':
        return 'Goal Reminder';
      case 'assessment_reminder':
        return 'Assessment Reminder';
      case 'test':
        return 'Test';
      case 'general':
      default:
        return 'General';
    }
  }
}
