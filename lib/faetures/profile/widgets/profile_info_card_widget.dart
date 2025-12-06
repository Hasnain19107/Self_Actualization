import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/const/app_exports.dart';

class ProfileInfoCardWidget extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const ProfileInfoCardWidget({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkwhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.inputBorderGrey,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.lightBlue.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.blue,
              size: 20,
            ),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  text: label,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.mediumGray,
                  textAlign: TextAlign.left,
                ),
                const Gap(4),
                CustomTextWidget(
                  text: value,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: valueColor ?? AppColors.black,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

