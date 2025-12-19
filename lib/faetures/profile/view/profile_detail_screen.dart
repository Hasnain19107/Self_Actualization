import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:self_actualisation/core/widgets/custom_back_button.dart';
import '../../../core/const/app_exports.dart';
import '../../../core/controllers/user_controller.dart';
import '../widgets/profile_info_card_widget.dart';
import '../widgets/profile_section_title_widget.dart';
import '../widgets/profile_avatar_section_widget.dart';
import '../widgets/profile_focus_areas_widget.dart';

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({super.key});

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
  }

  String _formatDateShort(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final AppSizes appSizes = AppSizes();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: appSizes.getWidthPercentage(3),
                vertical: appSizes.getHeightPercentage(2),
              ),
              child: Row(
                children: [
                  CustomBackButton(),
                  const Gap(12),
                  const Expanded(
                    child: CustomTextWidget(
                      text: 'Profile Details',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      textColor: AppColors.black,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.profileSetupScreen);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Obx(() {
                final userController = Get.isRegistered<UserController>()
                    ? Get.find<UserController>()
                    : null;
                final user = userController?.currentUser.value;

                if (userController?.isLoadingUser.value == true) {
                  return const Center(
                    child: CustomProgressIndicator(),
                  );
                }

                if (user == null) {
                  return Center(
                    child: CustomTextWidget(
                      text: 'No user data available',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      textColor: AppColors.mediumGray,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: appSizes.getWidthPercentage(3),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar Section
                      ProfileAvatarSectionWidget(user: user),
                      const Gap(32),

                      // Personal Information Section
                      const ProfileSectionTitleWidget(title: 'Personal Information'),
                      const Gap(16),
                      ProfileInfoCardWidget(
                        label: 'Name',
                        value: user.name,
                        icon: Icons.person_outline,
                      ),
                      const Gap(12),
                      ProfileInfoCardWidget(
                        label: 'Email',
                        value: user.email,
                        icon: Icons.email_outlined,
                      ),
                      const Gap(12),
                      ProfileInfoCardWidget(
                        label: 'Age',
                        value: user.age != null ? '${user.age} years' : 'N/A',
                        icon: Icons.cake_outlined,
                      ),
                      const Gap(32),

                      // Focus Areas Section
                      if (user.focusAreas != null && user.focusAreas!.isNotEmpty) ...[
                        const ProfileSectionTitleWidget(title: 'Focus Areas'),
                        const Gap(16),
                        ProfileFocusAreasWidget(focusAreas: user.focusAreas!),
                        const Gap(32),
                      ],

                      // Account Information Section
                      const ProfileSectionTitleWidget(title: 'Account Information'),
                      const Gap(16),
                      ProfileInfoCardWidget(
                        label: 'Subscription Plan',
                        value: user.currentSubscriptionType ?? 'No subscription',
                        icon: Icons.card_membership,
                        valueColor: user.currentSubscriptionType != null
                            ? AppColors.blue
                            : AppColors.mediumGray,
                      ),
                      const Gap(12),
                      ProfileInfoCardWidget(
                        label: 'Assessment Status',
                        value: user.hasCompletedAssessment == true
                            ? 'Completed'
                            : 'Not Completed',
                        icon: Icons.assignment_turned_in_outlined,
                        valueColor: user.hasCompletedAssessment == true
                            ? AppColors.green
                            : AppColors.mediumGray,
                      ),
                      const Gap(32),

                      // Activity Information Section
                      const ProfileSectionTitleWidget(title: 'Activity'),
                      const Gap(16),
                      ProfileInfoCardWidget(
                        label: 'Account Created',
                        value: _formatDateShort(user.createdAt),
                        icon: Icons.calendar_today_outlined,
                      ),
                      const Gap(12),
                      ProfileInfoCardWidget(
                        label: 'Last Updated',
                        value: _formatDateShort(user.updatedAt),
                        icon: Icons.update_outlined,
                      ),
                      const Gap(12),
                      if (user.lastLogin != null)
                        ProfileInfoCardWidget(
                          label: 'Last Login',
                          value: _formatDate(user.lastLogin),
                          icon: Icons.login_outlined,
                        ),
                      if (user.lastLogin != null) const Gap(12),
                      if (user.assessmentCompletedAt != null)
                        ProfileInfoCardWidget(
                          label: 'Assessment Completed',
                          value: _formatDate(user.assessmentCompletedAt),
                          icon: Icons.check_circle_outline,
                        ),
                      const Gap(32),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

}

