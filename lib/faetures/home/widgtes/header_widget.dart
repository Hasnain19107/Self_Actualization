import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';
import '../../../core/controllers/user_controller.dart';

class HeaderWidget extends StatelessWidget {
  final String userName;
  final String greeting;

  const HeaderWidget({
    super.key,
    required this.userName,
    required this.greeting,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // User profile section with avatar
        Obx(() {
          final userController = Get.isRegistered<UserController>()
              ? Get.find<UserController>()
              : null;
          final avatar = userController?.currentUser.value?.avatar;

          return GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.profileScreen),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.lightGray,
                border: Border.all(
                  color: AppColors.inputBorderGrey,
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: _buildAvatarImage(avatar),
              ),
            ),
          );
        }),

        // Notification bell
        IconButton(
          onPressed: () {
            Get.toNamed(AppRoutes.notificationScreen);
          },
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.black,
            size: 24,
          ),
        ),
      ],
    );
  }

  /// Build avatar image based on the avatar type (URL or asset path)
  Widget _buildAvatarImage(String? avatar) {
    // No avatar set - show default icon
    if (avatar == null || avatar.isEmpty) {
      return const Icon(Icons.person, size: 30, color: AppColors.black);
    }

    // Check if it's a URL (uploaded custom avatar)
    if (avatar.startsWith('http://') || avatar.startsWith('https://')) {
      return Image.network(
        avatar,
        fit: BoxFit.cover,
        width: 50,
        height: 50,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.person, size: 30, color: AppColors.black);
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
        return const Icon(Icons.person, size: 30, color: AppColors.black);
      },
    );
  }
}
