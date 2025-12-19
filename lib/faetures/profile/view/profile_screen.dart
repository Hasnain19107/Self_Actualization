import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_actualisation/faetures/profile/widgets/profile_avatar_section_widget.dart';
import '../../../core/const/app_exports.dart';
import '../../../core/controllers/user_controller.dart';
import '../binding/profile_binding.dart';
import '../controller/profile_controller.dart';
import '../widgets/profile_tab_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileBinding().dependencies();
    final controller = Get.find<ProfileController>();
    final AppSizes appSizes = AppSizes();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appSizes.getWidthPercentage(3),
            vertical: appSizes.getHeightPercentage(2),
          ),
          child: Obx(() {
            // Show loading for content area
            if (controller.isLoadingUserData.value) {
              return const Center(
                child: CustomProgressIndicator(),
              );
            }

            // Show error screen in content area
            if (controller.errorMessage.value.isNotEmpty) {
              return ErrorScreenWidget(
                errorMessage: controller.errorMessage.value,
                onRetry: () => controller.refreshData(),
              );
            }

            // Show content
            return SingleChildScrollView(
              child: Column(
                children: [
                  const Gap(12),

                  // Avatar and Name
                  Obx(() {
                    final userController = Get.isRegistered<UserController>()
                        ? Get.find<UserController>()
                        : null;
                    final user = userController?.currentUser.value;

                    if (user == null) {
                      return const SizedBox.shrink();
                    }

                    return ProfileAvatarSectionWidget(user: user);
                  }),
                  const Gap(40),

                  // Profile Tab
                  ProfileTabWidget(
                    title: 'Profile',
                    icon: Icons.person_outline,
                    onTap: () {
                      Get.toNamed(AppRoutes.profileDetailScreen);
                    },
                  ),
                  const Gap(16),

                  // Subscription Tab
                  ProfileTabWidget(
                    title: 'Subscription',
                    icon: Icons.card_membership,
                    onTap: () {
                      Get.toNamed(AppRoutes.subscriptionScreen);
                    },
                  ),
                  const Gap(16),

                  // Notification Tab
                  ProfileTabWidget(
                    title: 'Notifications',
                    icon: Icons.notifications_outlined,
                    onTap: () {
                      Get.toNamed(AppRoutes.notificationScreen);
                    },
                  ),
                  const Gap(40),

                  // Logout Button (scrollable with content)
                  Obx(() {
                    final isLoggingOut = controller.isLoggingOut.value;
                    return CustomElevatedButton(
                      text: 'Logout',
                      textColor: AppColors.red,
                      backgroundColor: AppColors.red.withOpacity(0.3),
                      borderRadius: 10,
                      height: 56,
                      isLoading: isLoggingOut,
                      onPress: () => controller.handleLogout(),
                      width: double.infinity,
                    );
                  }),
                  Gap(appSizes.getHeightPercentage(2)),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

