import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/const/app_exports.dart';

class ProfileTabWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData icon;

  const ProfileTabWidget({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: AppColors.darkwhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.inputBorderGrey,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
                const Gap(16),
                CustomTextWidget(
                  text: title,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.black,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.black,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

