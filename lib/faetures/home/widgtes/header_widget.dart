import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';

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
        // User profile section
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.lightGray,
          ),
          child: const Icon(Icons.person, size: 30, color: AppColors.black),
        ),

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
}
