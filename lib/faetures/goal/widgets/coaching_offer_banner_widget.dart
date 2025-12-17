import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/const/app_exports.dart';
import '../controller/goal_controller.dart';

class CoachingOfferBannerWidget extends StatelessWidget {
  final GoalController controller;

  const CoachingOfferBannerWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main content
          GestureDetector(
            onTap: () => controller.requestCoachingSession(),
            child: Row(
              children: [
                // Celebration Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.celebration,
                    color: AppColors.white,
                    size: 32,
                  ),
                ),
                const Gap(16),
                // Message
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                        text: 'Congratulations!',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.white,
                        textAlign: TextAlign.left,
                      ),
                      const Gap(4),
                      CustomTextWidget(
                        text: 'You got a free coaching session valued at \$500AUD. Tap here',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.white,
                        textAlign: TextAlign.left,
                        maxLines: 3,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Arrow Icon
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.white,
                  size: 20,
                ),
              ],
            ),
          ),
          // Close button
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => controller.dismissCoachingOffer(),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: AppColors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

