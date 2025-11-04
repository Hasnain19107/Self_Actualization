import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pixsa_petrol_pump/core/app_routes/app_routes.dart';
import 'package:pixsa_petrol_pump/core/utils/app_sizes.dart';
import 'package:pixsa_petrol_pump/core/widgets/custom_elevated_button.dart';
import 'package:pixsa_petrol_pump/core/widgets/custom_input_textfield.dart';
import 'package:pixsa_petrol_pump/core/widgets/custom_rich_text.dart';
import 'package:pixsa_petrol_pump/core/widgets/custom_text_widget.dart';
import '../../../core/Const/app_colors.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../core/widgets/curved_background.dart';
import '../../../core/const/app_images.dart';
import '../../../core/widgets/custom_svg_icon.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final AuthController controller = Get.find<AuthController>();
  final AppSizes appSizes = AppSizes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Curved blue background
            Stack(
              children: [
                CurvedBackground(
                  height: Get.height * 0.20,
                  child: SizedBox(height: Get.height * 0.20),
                ),
              ],
            ),
            // Main content below the curve
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: appSizes.getWidthPercentage(4),
                  ),
                  child: Column(
                    children: [
                      Gap(20),
                      CustomTextWidget(
                        text: "Sign In",
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.black,
                        fontSize: 28,
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
                      // Password Field
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
                      // Sign In Button
                      CustomElevatedButton(
                        text: "Sign In",
                        backgroundColor: AppColors.blue,
                        textColor: AppColors.white,
                        onPress: () {
                          Get.toNamed(AppRoutes.WELCOMESCREEN);
                        },
                        hasRightIcon: true,
                        iconColor: AppColors.white,
                        iconData: Icons.arrow_forward,
                        iconSize: 20,
                      ),
                      Gap(28),
                      // Social Login Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Facebook Button
                          GestureDetector(
                            onTap: () {
                              // Handle Facebook login
                            },
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white,
                                border: Border.all(
                                  color: AppColors.grey,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: CustomSvgIcon(
                                  path: AppImages.facebook,
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                            ),
                          ),
                          Gap(20),
                          // Google Button
                          GestureDetector(
                            onTap: () {
                              // Handle Google login
                            },
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white,
                                border: Border.all(
                                  color: AppColors.grey,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: CustomSvgIcon(
                                  path: AppImages.google,
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(32),
                      // Sign Up Link
                      CustomRichText(
                        text1: "Don't have an account? ",
                        text2: "Sign Up.",
                        onPress: () => Get.toNamed(AppRoutes.SIGNUPSCREEN),
                      ),
                      Gap(16),
                      // Forgot Password Link
                      InkWell(
                        onTap: () {
                          // Handle forgot password
                        },
                        child: CustomTextWidget(
                          text: "Forgot Password",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          textColor: AppColors.blue,
                        ),
                      ),
                      Gap(32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
