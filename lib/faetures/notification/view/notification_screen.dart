import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../binding/notification_binding.dart';
import '../controller/notification_controller.dart';
import '../widgets/notification_card_widget.dart';
import '../widgets/notification_header_widget.dart';
import '../../../core/const/app_exports.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationBinding().dependencies();
    final controller = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(12),
            // Header with title and actions
            const NotificationHeaderWidget(),
            const Gap(8),

            // Filter chips
            _buildFilterChips(controller),
            const Gap(8),

            // Notification List
            Expanded(
              child: Obx(() {
                // Loading state
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }

                // Error state
                if (controller.hasError.value) {
                  return _buildErrorState(controller);
                }

                // Empty state
                if (controller.isEmpty) {
                  return _buildEmptyState(controller);
                }

                // Notification list
                return RefreshIndicator(
                  onRefresh: controller.refresh,
                  color: AppColors.primary,
                  child: ListView.builder(
                    itemCount: controller.notifications.length +
                        (controller.hasMorePages ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Load more indicator
                      if (index == controller.notifications.length) {
                        // Trigger load more
                        if (!controller.isLoadingMore.value) {
                          controller.loadMore();
                        }
                        return _buildLoadMoreIndicator(controller);
                      }

                      final notification = controller.notifications[index];
                      return NotificationCardWidget(
                        notification: notification,
                        onTap: () {
                          // Mark as read when tapped
                          if (!notification.isRead) {
                            controller.markAsRead(notification.id);
                          }
                          // Navigate based on notification data
                          _handleNotificationTap(notification);
                        },
                        onDismiss: () {
                          controller.deleteNotification(notification.id);
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(NotificationController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => Row(
          children: [
            _buildFilterChip(
              label: 'All',
              isSelected: controller.selectedType.value == null &&
                  controller.selectedIsRead.value == null,
              onTap: () => controller.clearFilters(),
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Unread',
              isSelected: controller.selectedIsRead.value == false,
              onTap: () => controller.filterByReadStatus(false),
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Goal Reminder',
              isSelected: controller.selectedType.value == 'goal_reminder',
              onTap: () => controller.filterByType('goal_reminder'),
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Goal Completed',
              isSelected: controller.selectedType.value == 'goal_completed',
              onTap: () => controller.filterByType('goal_completed'),
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Assessment',
              isSelected:
                  controller.selectedType.value == 'assessment_reminder',
              onTap: () => controller.filterByType('assessment_reminder'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: CustomTextWidget(
          text: label,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          textColor: isSelected ? AppColors.white : Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildErrorState(NotificationController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const Gap(16),
            CustomTextWidget(
              text: 'Something went wrong',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              textColor: Colors.grey.shade700,
            ),
            const Gap(8),
            CustomTextWidget(
              text: controller.errorMessage.value,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: Colors.grey.shade500,
              textAlign: TextAlign.center,
            ),
            const Gap(24),
            CustomElevatedButton(
              text: 'Try Again',
              onPress: () => controller.refresh(),
              isLoading: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(NotificationController controller) {
    final hasFilters = controller.selectedType.value != null ||
        controller.selectedIsRead.value != null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasFilters
                    ? Icons.filter_list_off
                    : Icons.notifications_off_outlined,
                size: 48,
                color: Colors.grey.shade400,
              ),
            ),
            const Gap(24),
            CustomTextWidget(
              text: hasFilters ? 'No matching notifications' : 'No notifications yet',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              textColor: Colors.grey.shade700,
            ),
            const Gap(8),
            CustomTextWidget(
              text: hasFilters
                  ? 'Try adjusting your filters to see more results'
                  : 'When you receive notifications, they\'ll appear here',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: Colors.grey.shade500,
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              const Gap(24),
              TextButton(
                onPressed: () => controller.clearFilters(),
                child: const Text(
                  'Clear Filters',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreIndicator(NotificationController controller) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: controller.isLoadingMore.value
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  void _handleNotificationTap(notification) {
    final data = notification.data;
    if (data?.screen != null) {
      // Navigate to the specified screen
      Get.toNamed(data!.screen!);
    }
  }
}
