import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_actualisation/core/widgets/custom_back_button.dart';
import '../../../core/const/app_exports.dart';
import '../../../core/widgets/custom_toast_show.dart';
import '../controller/notification_controller.dart';

class NotificationHeaderWidget extends StatelessWidget {
  const NotificationHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
         CustomBackButton(),
         const Gap(12),
          Expanded(
            child: Obx(
              () => Row(
                children: [
                  const CustomTextWidget(
                    text: 'Notifications',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    textColor: AppColors.black,
                    textAlign: TextAlign.left,
                  ),
                  if (controller.unreadCount.value > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomTextWidget(
                        text: controller.unreadCount.value > 99
                            ? '99+'
                            : controller.unreadCount.value.toString(),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        textColor: AppColors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // More options menu
          PopupMenuButton<String>(
            color: AppColors.white,
            icon: const Icon(Icons.more_vert, color: AppColors.black),
            onSelected: (value) => _handleMenuAction(value, controller),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Row(
                  children: [
                    Icon(Icons.done_all, size: 20, color: AppColors.primary),
                    SizedBox(width: 12),
                    Text('Mark all as read'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, size: 20, color: AppColors.red),
                    SizedBox(width: 12),
                    Text('Delete all'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action, NotificationController controller) {
    switch (action) {
      case 'mark_all_read':
        _confirmMarkAllRead(controller);
        break;
      case 'delete_all':
        _confirmDeleteAll(controller);
        break;
    }
  }

  void _confirmMarkAllRead(NotificationController controller) {
    if (controller.unreadCount.value == 0) {
      ToastClass.showCustomToast('No unread notifications');
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Mark All as Read'),
        content: Text(
          'Mark all ${controller.unreadCount.value} unread notifications as read?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.markAllAsRead();
            },
            child: const Text(
              'Mark All',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAll(NotificationController controller) {
    if (controller.notifications.isEmpty) {
      ToastClass.showCustomToast('No notifications to delete');
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Delete All Notifications'),
        content: Text(
          'Are you sure you want to delete all ${controller.totalNotifications.value} notifications? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteAllNotifications();
            },
            child: const Text(
              'Delete All',
              style: TextStyle(color: AppColors.red),
            ),
          ),
        ],
      ),
    );
  }
}
