import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';
import '../controller/onboarding_controller.dart';
import '../widget/onboarding_page_widget.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final OnboardingController controller = Get.find<OnboardingController>();

  /// Define the 5 onboarding pages with their content
  List<OnboardingPageWidget> get pages => [
    // Page 1: Welcome
    const OnboardingPageWidget(
      title: 'Welcome to Your Journey',
      description:
          'Discover your path to self-actualization—the highest level of personal fulfillment and becoming the best version of yourself.',
      iconData: Icons.auto_awesome,
      gradientColors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    ),

    // Page 2: Deficiency Needs
    const OnboardingPageWidget(
      title: 'Deficiency Needs',
      subtitle: 'The Foundation',
      description:
          'Track your foundational needs: Survival, Safety, Social connection, and Self-esteem. These must be satisfied before reaching higher fulfillment.',
      iconData: Icons.foundation,
      gradientColors: [Color(0xFF14B8A6), Color(0xFF22D3EE)],
    ),

    // Page 3: Being Needs
    const OnboardingPageWidget(
      title: 'Being Needs',
      subtitle: 'Meta-Needs',
      description:
          'Explore higher aspirations: Purpose, Creativity, Authenticity, and Transcendence. These lead to peak experiences and lasting fulfillment.',
      iconData: Icons.psychology,
      gradientColors: [Color(0xFFF59E0B), Color(0xFFF97316)],
    ),

    // Page 4: Track Progress
    const OnboardingPageWidget(
      title: 'Track Your Progress',
      description:
          'Monitor both need categories to identify where to focus for optimal life quality and personal development.',
      iconData: Icons.insights,
      gradientColors: [Color(0xFFEC4899), Color(0xFFF43F5E)],
    ),

    // Page 5: Get Started
    const OnboardingPageWidget(
      title: "Let's Begin",
      description:
          'Start your personalized self-actualization journey today. Complete a quick assessment to discover where you stand.',
      iconData: Icons.rocket_launch,
      gradientColors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Obx(
                () => controller.isLastPage
                    ? const SizedBox(height: 48)
                    : TextButton(
                        onPressed: controller.skipToEnd,
                        child: const CustomTextWidget(
                          text: 'Skip',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          textColor: AppColors.mediumGray,
                        ),
                      ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: controller.totalPages,
                onPageChanged: controller.onPageChanged,
                itemBuilder: (context, index) => pages[index],
              ),
            ),

            // Page indicator
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.totalPages,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: controller.currentPage.value == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: controller.currentPage.value == index
                          ? AppColors.primary
                          : AppColors.grey2,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Next/Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Obx(
                () => CustomElevatedButton(
                  text: controller.isLastPage ? 'Get Started' : 'Next',
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.white,
                  onPress: controller.nextPage,
                  hasRightIcon: true,
                  iconData: controller.isLastPage
                      ? Icons.check
                      : Icons.arrow_forward,
                  iconColor: AppColors.white,
                  iconSize: 20,
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
