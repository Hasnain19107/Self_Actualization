import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final AuthController controller = Get.find<AuthController>();
  final AppSizes appSizes = AppSizes();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: appSizes.getWidthPercentage(3),
                      vertical: appSizes.getHeightPercentage(2),
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
                          textEditingController: controller.signinEmailController,
                          customPrefixIcon: Icons.email_outlined,
                          prefixIconColor: AppColors.blue,
                          validator: controller.validateEmail,
                          isValidator: false,
                        ),
                        Gap(24),
                        // Password Field
                        CustomInputTextField(
                          labelText: "Password",
                          hintText: "Enter your password...",
                          hintColor: AppColors.grey,
                          hasSuffixIcon: true,
                          isObscure: true,
                          textEditingController: controller.signinPasswordController,
                          customPrefixIcon: Icons.lock_outline,
                          prefixIconColor: AppColors.blue,
                          validator: controller.validatePassword,
                          isValidator: false,
                        ),
                        Gap(28),
                        // Sign In Button
                        Obx(
                          () => CustomElevatedButton(
                            text: "Sign In",
                            backgroundColor: AppColors.blue,
                            textColor: AppColors.white,
                            isLoading: controller.isLoading.value,
                            onPress: () {
                              if (_formKey.currentState!.validate()) {
                                controller.signIn();
                              }
                            },
                            hasRightIcon: !controller.isLoading.value,
                            iconColor: AppColors.white,
                            iconData: Icons.arrow_forward,
                            iconSize: 20,
                          ),
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
                          onPress: () => Get.toNamed(AppRoutes.signUpScreen),
                        ),
                        Gap(16),
                        // Forgot Password Link
                        InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.forgotPasswordScreen);
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
            ),
          ],
        ),
      ),
    );
  }
}
