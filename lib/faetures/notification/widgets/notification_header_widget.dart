import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';

class NotificationHeaderWidget extends StatelessWidget {
  const NotificationHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back, color: AppColors.black, size: 24),
          ),
          CustomTextWidget(
            text: 'Notifications',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            textColor: AppColors.black,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
