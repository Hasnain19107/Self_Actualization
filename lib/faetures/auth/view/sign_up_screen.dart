import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pixsa_petrol_pump/core/utils/app_sizes.dart';
import '../../../core/Const/app_colors.dart';
import 'package:get/get.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../../../core/widgets/custom_input_textfield.dart';
import '../../../core/widgets/custom_rich_text.dart';
import '../../../core/widgets/custom_text_widget.dart';
import '../../../core/widgets/plan_card_widget.dart';
import '../controllers/auth_controller.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final AuthController controller = Get.find<AuthController>();
  final AppSizes appSizes = AppSizes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: appSizes.getWidthPercentage(4),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(32),
                // Sign Up Title
                Center(
                  child: CustomTextWidget(
                    text: "Sign Up",
                    fontWeight: FontWeight.w700,
                    textColor: AppColors.black,
                    fontSize: 28,
                  ),
                ),
                Gap(32),
                // Email Address Field
                CustomInputTextField(
                  labelText: "Email Address",
                  hintText: "Enter your email...",
                  hintColor: AppColors.grey,
                  textEditingController: controller.emailController,
                  customPrefixIcon: Icons.email_outlined,
                  prefixIconColor: AppColors.blue,
                ),
                Gap(24),
                // Full Name Field
                CustomInputTextField(
                  labelText: "Full Name",
                  hintText: "Enter your full name",
                  hintColor: AppColors.grey,
                  textEditingController: controller.fullNameController,
                  customPrefixIcon: Icons.person_outline,
                  prefixIconColor: AppColors.blue,
                ),
                Gap(24),
                // Select Plan Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextWidget(
                    text: "Select Plan",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.black,
                  ),
                ),
                Gap(12),
                // Plan Cards Row
                Obx(
                  () => Row(
                    children: [
                      PlanCardWidget(
                        planName: "Free",
                        price: "\$0",
                        isSelected: controller.selectedPlan.value == 'Free',
                        onTap: () => controller.selectedPlan.value = 'Free',
                      ),
                      Gap(8),
                      PlanCardWidget(
                        planName: "Premium",
                        price: "\$19",
                        isSelected: controller.selectedPlan.value == 'Premium',
                        onTap: () => controller.selectedPlan.value = 'Premium',
                      ),
                      Gap(8),
                    ],
                  ),
                ),
                Gap(10),
                PlanCardWidget(
                  planName: "Coach",
                  price: "\$39",
                  isSelected: controller.selectedPlan.value == 'Coach',
                  onTap: () => controller.selectedPlan.value = 'Coach',
                ),
                // Password Field
                Gap(20),
                CustomInputTextField(
                  labelText: "Password",
                  hintText: "Enter your password...",
                  hintColor: AppColors.grey,
                  hasSuffixIcon: true,
                  isObscure: true,
                  textEditingController: controller.passwordController,
                  customPrefixIcon: Icons.lock_outline,
                  prefixIconColor: AppColors.blue,
                ),
                Gap(28),
                // Sign Up Button
                CustomElevatedButton(
                  text: "Sign Up",
                  backgroundColor: AppColors.blue,
                  textColor: AppColors.white,
                  onPress: () {
                    // Handle sign up
                  },
                  hasRightIcon: true,
                  iconColor: AppColors.white,
                  iconData: Icons.arrow_forward,
                  iconSize: 20,
                ),
                Gap(28),
                // Sign In Link
                CustomRichText(
                  text1: "Already have an account? ",
                  text2: "Sign In.",
                  onPress: () => Get.toNamed(AppRoutes.LOGINSCREEN),
                ),
                Gap(32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
