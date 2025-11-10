import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/const/app_exports.dart';

class GoalCardWidget extends StatelessWidget {
  final String emoji;
  final String title;
  final String category;
  final String date;

  const GoalCardWidget({
    super.key,
    required this.emoji,
    required this.title,
    required this.category,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.darkwhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Emoji icon with light yellow background
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.white, // Light yellow
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const Gap(8),
          // Title
          Expanded(
            child: CustomTextWidget(
              text: title,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              textColor: AppColors.black,
              textAlign: TextAlign.left,
            ),
          ),
          const Gap(12),

          // Category and date badge
          CustomTextWidget(
            text: category,
            fontSize: 10,
            fontWeight: FontWeight.w400,
            textColor: AppColors.black,
            textAlign: TextAlign.right,
          ),
          const Gap(4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: CustomTextWidget(
              text: date,
              fontSize: 10,
              fontWeight: FontWeight.w400,
              textColor: AppColors.white,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
