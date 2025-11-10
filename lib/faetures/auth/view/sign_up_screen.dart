import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/const/app_exports.dart';

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
                    textEditingController: controller.emailController,
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
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            PlanCardWidget(
                              planName: "Free",
                              price: "\$0",
                              isSelected:
                                  controller.selectedPlan.value == 'Free',
                              onTap: () {
                                controller.selectedPlan.value = 'Free';
                                controller.planValidationError.value = '';
                              },
                            ),
                            Gap(8),
                            PlanCardWidget(
                              planName: "Premium",
                              price: "\$19",
                              isSelected:
                                  controller.selectedPlan.value == 'Premium',
                              onTap: () {
                                controller.selectedPlan.value = 'Premium';
                                controller.planValidationError.value = '';
                              },
                            ),
                            Gap(8),
                          ],
                        ),
                        Gap(10),
                        PlanCardWidget(
                          planName: "Coach",
                          price: "\$39",
                          isSelected: controller.selectedPlan.value == 'Coach',
                          onTap: () {
                            controller.selectedPlan.value = 'Coach';
                            controller.planValidationError.value = '';
                          },
                        ),
                        if (controller.planValidationError.value.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              left: 12.0,
                            ),
                            child: CustomTextWidget(
                              text: controller.planValidationError.value,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              textColor: AppColors.red,
                            ),
                          ),
                      ],
                    ),
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
                        // Clear previous plan validation error
                        controller.planValidationError.value = '';

                        // Validate form fields
                        if (_formKey.currentState!.validate()) {
                          // Validate plan selection
                          final planError = controller.validatePlan();
                          if (planError != null) {
                            controller.planValidationError.value = planError;
                            return;
                          }
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
