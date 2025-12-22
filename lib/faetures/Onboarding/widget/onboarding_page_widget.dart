import 'package:flutter/material.dart';
import '../../../core/const/app_exports.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String title;
  final String description;
  final IconData iconData;
  final List<Color> gradientColors;
  final String? subtitle;

  const OnboardingPageWidget({
    super.key,
    required this.title,
    required this.description,
    required this.iconData,
    required this.gradientColors,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with gradient background
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: gradientColors.first.withValues(alpha: 0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(iconData, size: 80, color: AppColors.white),
          ),
          const SizedBox(height: 48),

          // Title
          CustomTextWidget(
            text: title,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            textColor: AppColors.primaryColor,
            textAlign: TextAlign.center,
            maxLines: null,
            textOverflow: TextOverflow.visible,
          ),

          // Subtitle (optional)
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            CustomTextWidget(
              text: subtitle!,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textColor: gradientColors.first,
              textAlign: TextAlign.center,
              maxLines: null,
              textOverflow: TextOverflow.visible,
            ),
          ],

          const SizedBox(height: 20),

          // Description
          CustomTextWidget(
            text: description,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            textColor: AppColors.mediumGray,
            textAlign: TextAlign.center,
            maxLines: null,
            textOverflow: TextOverflow.visible,
          ),
        ],
      ),
    );
  }
}
