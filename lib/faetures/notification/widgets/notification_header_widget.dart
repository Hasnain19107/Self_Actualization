import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';

class NotificationHeaderWidget extends StatelessWidget {
  const NotificationHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Gap(16),
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.inputBorderGrey, width: 1),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.black,
              size: 20,
            ),
          ),
        ),
        const Gap(16),
        CustomTextWidget(
          text: 'Notifications',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          textColor: AppColors.black,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}
