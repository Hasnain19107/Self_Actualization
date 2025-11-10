import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/const/app_exports.dart';

class GoalItemWidget extends StatelessWidget {
  final Color barColor;
  final String title;
  final String subtitle;

  const GoalItemWidget({
    super.key,
    required this.barColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 30,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  text: title,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.black,
                  textAlign: TextAlign.left,
                ),
                CustomTextWidget(
                  text: subtitle,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.mediumGray,
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
