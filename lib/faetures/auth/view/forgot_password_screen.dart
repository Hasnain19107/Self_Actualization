import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/const/app_exports.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final AuthController controller = Get.find<AuthController>();
  final AppSizes appSizes = AppSizes();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: appSizes.getWidthPercentage(3),
                vertical: appSizes.getHeightPercentage(2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(32),
                  // Forgot Password Title
                  Center(
                    child: CustomTextWidget(
                      text: "Forgot Password",
                      fontWeight: FontWeight.w700,
                      textColor: AppColors.black,
                      fontSize: 28,
                    ),
                  ),
                  Gap(16),
                  // Description
                  Center(
                    child: CustomTextWidget(
                      text: "Enter your email address and we'll send you a link to reset your password.",
                      fontWeight: FontWeight.w400,
                      textColor: AppColors.grey,
                      fontSize: 14,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gap(32),
                  // Email Address Field
                  CustomInputTextField(
                    labelText: "Email Address",
                    hintText: "Enter your email...",
                    hintColor: AppColors.grey,
                    textEditingController: controller.forgotPasswordEmailController,
                    customPrefixIcon: Icons.email_outlined,
                    prefixIconColor: AppColors.blue,
                    validator: controller.validateEmail,
                    isValidator: false,
                  ),
                  Gap(28),
                  // Send Reset Link Button
                  Obx(
                    () => CustomElevatedButton(
                      text: "Send Reset Link",
                      backgroundColor: AppColors.blue,
                      textColor: AppColors.white,
                      isLoading: controller.isLoading.value,
                      onPress: () {
                        // Validate form fields
                        if (_formKey.currentState!.validate()) {
                          // All validations passed, proceed with forgot password
                          controller.forgotPassword();
                        }
                      },
                      hasRightIcon: !controller.isLoading.value,
                      iconColor: AppColors.white,
                      iconData: Icons.arrow_forward,
                      iconSize: 20,
                    ),
                  ),
                  Gap(28),
                  // Sign In Link
                  CustomRichText(
                    text1: "Remember your password? ",
                    text2: "Sign In.",
                    onPress: () => Get.toNamed(AppRoutes.loginScreen),
                  ),
                  Gap(32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

