import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../const/app_exports.dart';
import '../controllers/user_controller.dart';

/// Upgrade Banner Widget
/// Shows a promotional banner to upgrade subscription based on current plan
class UpgradeBannerWidget extends StatelessWidget {
  final bool showDismiss;
  final VoidCallback? onDismiss;

  const UpgradeBannerWidget({
    super.key,
    this.showDismiss = true,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    // Check if UserController is registered
    final userController = Get.isRegistered<UserController>()
        ? Get.find<UserController>()
        : null;

    // If no controller, show banner for Free plan by default
    if (userController == null) {
      return _buildBanner(isFreePlan: true);
    }

    return Obx(() {
      final subscriptionType = userController.subscriptionType.toLowerCase();

      // Don't show banner for Coach plan users (they have everything)
      if (subscriptionType == 'coach') {
        return const SizedBox.shrink();
      }

      // Determine what to show based on plan
      final isFreePlan = subscriptionType == 'free' || subscriptionType.isEmpty;

      return _buildBanner(isFreePlan: isFreePlan);
    });
  }

  Widget _buildBanner({required bool isFreePlan}) {

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isFreePlan
                ? [AppColors.blue, AppColors.blue.withOpacity(0.8)]
                : [const Color(0xFF9C27B0), const Color(0xFF7B1FA2)], // Purple for Coach upgrade
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (isFreePlan ? AppColors.blue : const Color(0xFF9C27B0))
                  .withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isFreePlan ? Icons.rocket_launch : Icons.stars,
                          color: AppColors.white,
                          size: 24,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                              text: isFreePlan
                                  ? 'Unlock Your Full Potential'
                                  : 'Discover Meta-Needs',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              textColor: AppColors.white,
                              textAlign: TextAlign.left,
                            ),
                            const Gap(4),
                            CustomTextWidget(
                              text: isFreePlan
                                  ? 'Upgrade to access Social & Self levels'
                                  : 'Upgrade to Coach for human meta-needs',
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              textColor: AppColors.white.withOpacity(0.9),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  // What you'll unlock
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextWidget(
                          text: isFreePlan ? 'Premium unlocks:' : 'Coach unlocks:',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          textColor: AppColors.white.withOpacity(0.9),
                          textAlign: TextAlign.left,
                        ),
                        const Gap(8),
                        if (isFreePlan) ...[
                          _buildUnlockItem('💬', 'Social Level - Connection & belonging'),
                          const Gap(4),
                          _buildUnlockItem('✏️', 'Self Level - Growth & achievement'),
                        ] else ...[
                          _buildUnlockItem('🧠', 'Cognitive - Know, understand, learn'),
                          const Gap(4),
                          _buildUnlockItem('💝', 'Love - Care & extend yourself'),
                          const Gap(4),
                          _buildUnlockItem('✨', 'Truth, Beauty & Contribution'),
                        ],
                      ],
                    ),
                  ),
                  const Gap(12),
                  // Upgrade button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.selectPlanScreen);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: isFreePlan ? AppColors.blue : const Color(0xFF7B1FA2),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isFreePlan ? 'Upgrade to Premium' : 'Upgrade to Coach',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isFreePlan ? AppColors.blue : const Color(0xFF7B1FA2),
                            ),
                          ),
                          const Gap(8),
                          Icon(
                            Icons.arrow_forward,
                            size: 18,
                            color: isFreePlan ? AppColors.blue : const Color(0xFF7B1FA2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Dismiss button
            if (showDismiss)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onDismiss,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: AppColors.white.withOpacity(0.8),
                      size: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
  }

  Widget _buildUnlockItem(String emoji, String text) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const Gap(8),
        Expanded(
          child: CustomTextWidget(
            text: text,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            textColor: AppColors.white,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}

/// Upgrade Dialog Widget
/// Shows a popup dialog prompting upgrade
class UpgradeDialogWidget {
  static Future<void> show({
    required String title,
    required String message,
    required List<String> features,
    required String buttonText,
    bool isCoachUpgrade = false,
  }) async {
    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isCoachUpgrade
                        ? [const Color(0xFF9C27B0), const Color(0xFF7B1FA2)]
                        : [AppColors.blue, AppColors.blue.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCoachUpgrade ? Icons.stars : Icons.lock_open,
                  color: AppColors.white,
                  size: 32,
                ),
              ),
              const Gap(16),
              // Title
              CustomTextWidget(
                text: title,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                textColor: AppColors.black,
                textAlign: TextAlign.center,
              ),
              const Gap(8),
              // Message
              CustomTextWidget(
                text: message,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                textColor: AppColors.mediumGray,
                textAlign: TextAlign.center,
              ),
              const Gap(16),
              // Features
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: features
                      .map((feature) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: isCoachUpgrade
                                      ? const Color(0xFF9C27B0)
                                      : AppColors.blue,
                                  size: 18,
                                ),
                                const Gap(8),
                                Expanded(
                                  child: CustomTextWidget(
                                    text: feature,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    textColor: AppColors.black,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
              const Gap(20),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: CustomTextWidget(
                        text: 'Maybe Later',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.mediumGray,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.toNamed(AppRoutes.selectPlanScreen);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCoachUpgrade
                            ? const Color(0xFF9C27B0)
                            : AppColors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: CustomTextWidget(
                        text: buttonText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: AppColors.white,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  /// Show upgrade dialog for Free users wanting to access Social/Self levels
  static Future<void> showPremiumUpgrade() async {
    await show(
      title: 'Unlock Human Needs',
      message: 'Upgrade to Premium to access Social and Self levels - the higher human needs.',
      features: [
        '💬 Social Level - Connection & belonging',
        '✏️ Self Level - Growth & self-actualization',
        '📊 Advanced insights & tracking',
        '🎯 Personalized goal recommendations',
      ],
      buttonText: 'Upgrade',
      isCoachUpgrade: false,
    );
  }

  /// Show upgrade dialog for Premium users wanting to access Meta-needs
  static Future<void> showCoachUpgrade() async {
    await show(
      title: 'Discover Meta-Needs',
      message: 'Upgrade to Coach to unlock the highest human needs - the meta-needs that lead to self-transcendence.',
      features: [
        '🧠 Cognitive - Know, understand, learn',
        '💝 Love - Care & extend yourself to others',
        '✨ Truth - Know what is real & authentic',
        '🎨 Aesthetic - See, enjoy & create beauty',
        '🌟 Contribution - Make a difference',
        '🧭 Conative - Choose your unique way',
      ],
      buttonText: 'Upgrade',
      isCoachUpgrade: true,
    );
  }
}
