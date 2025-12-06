import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';

class LogoutDialogWidget extends StatelessWidget {
  const LogoutDialogWidget({super.key});

  static Future<bool?> show() {
    return Get.dialog<bool>(
      const LogoutDialogWidget(),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout,
                color: AppColors.red,
                size: 30,
              ),
            ),
            const Gap(20),
            // Title
            const CustomTextWidget(
              text: 'Logout',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              textColor: AppColors.black,
              textAlign: TextAlign.center,
            ),
            const Gap(12),
            // Message
            const CustomTextWidget(
              text: 'Are you sure you want to logout?',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: AppColors.mediumGray,
              textAlign: TextAlign.center,
            ),
            const Gap(24),
            // Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(result: false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.darkwhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.inputBorderGrey,
                          width: 1,
                        ),
                      ),
                      child: const CustomTextWidget(
                        text: 'Cancel',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: AppColors.black,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                // Logout Button
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(result: true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const CustomTextWidget(
                        text: 'Logout',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: AppColors.white,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

