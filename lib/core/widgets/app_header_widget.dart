import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../const/app_exports.dart';

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
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
                child: ClipOval(
                  child: Image.asset(
                    profileImagePath ?? AppImages.avatar1,
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
              )
            else
              const SizedBox(width: 50),
            // Title

            // Bell Icon
            if (showNotification)
              IconButton(
                onPressed: onNotificationTap,
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
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
        Gap(20),
        if (title.isNotEmpty)
          CustomTextWidget(
            text: title,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            textColor: AppColors.black,
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
