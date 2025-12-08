import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../const/app_exports.dart';
import '../controllers/user_controller.dart';

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

            // Bell Icon
            if (showNotification)
              IconButton(
                onPressed: onNotificationTap ??
                    () => Get.toNamed(AppRoutes.notificationScreen),
                icon: Container(
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
