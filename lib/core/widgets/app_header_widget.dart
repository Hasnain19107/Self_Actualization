import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../const/app_exports.dart';
import '../controllers/user_controller.dart';
import '../../faetures/notification/controller/notification_controller.dart';

class AppHeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onNotificationTap;
  final String? profileImagePath;
  final bool showProfile;
  final bool showNotification;

  const AppHeaderWidget({
    super.key,
    this.title = '',
    this.onNotificationTap,
    this.profileImagePath,
    this.showProfile = true,
    this.showNotification = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Profile Picture
            if (showProfile)
              Obx(() {
                final userController = Get.isRegistered<UserController>()
                    ? Get.find<UserController>()
                    : null;
                final avatarPath = profileImagePath ??
                    userController?.currentUser.value?.avatar;

                return GestureDetector(
                  onTap: () {
                   
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.inputBorderGrey,
                        width: 1,
                      ),
                    ),
                    child: ClipOval(
                      child: _buildAvatarImage(avatarPath),
                    ),
                  ),
                );
              })
            else
              const SizedBox(width: 50),

            // Bell Icon with unread indicator
            if (showNotification)
              GestureDetector(
                onTap: onNotificationTap ??
                    () => Get.toNamed(AppRoutes.notificationScreen),
                child: _buildNotificationIcon(),
              )
            else
              const SizedBox(width: 40),
          ],
        ),

        const Gap(20),

        if (title.isNotEmpty)
          CustomTextWidget(
            text: title,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            textColor: AppColors.black,
          ),
      ],
    );
  }

  /// Build notification icon with unread indicator
  Widget _buildNotificationIcon() {
    // Check if NotificationController is registered
    final notificationController = Get.isRegistered<NotificationController>()
        ? Get.find<NotificationController>()
        : null;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: AppColors.black,
            size: 24,
          ),
        ),
        // Red dot indicator for unread notifications
        if (notificationController != null)
          Obx(() {
            final hasUnread = notificationController.unreadCount.value > 0;
            if (!hasUnread) return const SizedBox.shrink();
            
            return Positioned(
              right: 2,
              top: 2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.white,
                    width: 2,
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }

  /// Build avatar image based on the avatar type (URL or asset path)
  Widget _buildAvatarImage(String? avatar) {
    // No avatar set - show default icon
    if (avatar == null || avatar.isEmpty) {
      return Container(
        color: AppColors.lightGray,
        child: const Icon(
          Icons.person,
          size: 30,
          color: AppColors.white,
        ),
      );
    }

    // Check if it's a URL (uploaded custom avatar)
    if (avatar.startsWith('http://') || avatar.startsWith('https://')) {
      return Image.network(
        avatar,
        fit: BoxFit.cover,
        width: 50,
        height: 50,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.lightGray,
            child: const Icon(
              Icons.person,
              size: 30,
              color: AppColors.white,
            ),
          );
        },
      );
    }

    // Asset path (preset avatar)
    return Image.asset(
      avatar,
      fit: BoxFit.cover,
      width: 50,
      height: 50,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: AppColors.lightGray,
          child: const Icon(
            Icons.person,
            size: 30,
            color: AppColors.white,
          ),
        );
      },
    );
  }
}
