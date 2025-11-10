import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/const/app_exports.dart';

class AddReflectionButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  const AddReflectionButtonWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(41),
          border: Border.all(color: AppColors.inputBorderGrey, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextWidget(
              text: 'Add New Reflection',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              textColor: AppColors.black,
              textAlign: TextAlign.center,
            ),
            const Gap(12),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: AppColors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
