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
                    (userController?.currentUser.value?.avatar ?? AppImages.avatar1);

                return Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      avatarPath,
                      fit: BoxFit.cover,
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
}
