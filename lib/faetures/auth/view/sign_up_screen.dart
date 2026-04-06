import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';
import '../widgets/social_login_section.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

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
                    textEditingController: controller.signupEmailController,
                    customPrefixIcon: Icons.email_outlined,
                    prefixIconColor: AppColors.blue,
                    validator: controller.validateEmail,
                    isValidator: false,
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
                    validator: controller.validateFullName,
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
                    textEditingController: controller.signupPasswordController,
                    customPrefixIcon: Icons.lock_outline,
                    prefixIconColor: AppColors.blue,
                    validator: controller.validatePassword,
                    isValidator: false,
                  ),
                  Gap(28),
                  // Sign Up Button
                  Obx(
                    () => CustomElevatedButton(
                      text: "Sign Up",
                      backgroundColor: AppColors.blue,
                      textColor: AppColors.white,
                      isLoading: controller.isLoading.value,
                      onPress: () {
                        // Validate form fields
                        if (_formKey.currentState!.validate()) {
                          // All validations passed, proceed with sign up
                          controller.signUp();
                        }
                      },
                      hasRightIcon: !controller.isLoading.value,
                      iconColor: AppColors.white,
                      iconData: Icons.arrow_forward,
                      iconSize: 20,
                    ),
                  ),
                  Gap(28),
                  SocialLoginSection(
                    controller: controller,
                    googleButtonText: 'Sign up with Google',
                    appleButtonText: 'Sign up with Apple',
                  ),
                  Gap(28),
                  // Sign In Link
                  CustomRichText(
                    text1: "Already have an account? ",
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
