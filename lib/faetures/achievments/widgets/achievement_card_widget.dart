import 'package:flutter/material.dart';
import '../../../core/const/app_exports.dart';

class AchievementCardWidget extends StatelessWidget {
  final String? imagePath;
  final String title;
  final String subtitle;

  const AchievementCardWidget({
    super.key,
    this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image from assets or fallback container
          imagePath != null && imagePath!.isNotEmpty
              ? Image.asset(
                  imagePath!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildFallbackContainer();
                  },
                )
              : _buildFallbackContainer(),
          const SizedBox(height: 12),
          // Title
          CustomTextWidget(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            textColor: AppColors.black,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // Subtitle
          CustomTextWidget(
            text: subtitle,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            textColor: AppColors.black,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackContainer() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.emoji_events, color: AppColors.black, size: 30),
    );
  }
}
