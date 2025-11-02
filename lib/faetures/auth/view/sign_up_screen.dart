import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pixsa_petrol_pump/core/utils/app_sizes.dart';
import '../../../core/Const/app_colors.dart';
import '../../../core/Const/app_images.dart';
import 'package:get/get.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../../../core/widgets/custom_input_textfield.dart';
import '../../../core/widgets/custom_rich_text.dart';
import '../../../core/widgets/custom_text_widget.dart';
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
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: appSizes.getCustomPadding(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.logo,
                    width: appSizes.getWidthPercentage(30),
                  ),
                  Gap(12),
                  CustomTextWidget(
                    text: "Create Account!",
                    fontWeight: FontWeight.w700,
                    textColor: AppColors.primaryColor,
                    fontSize: 20,
                  ),
                  Gap(appSizes.getHeightPercentage(10)),
                  CustomInputTextField(
                    hintText: "Enter Email",
                    hintColor: AppColors.grey,
                    textEditingController: controller.emailController,
                  ),
                  Gap(18),
                  CustomInputTextField(
                    hintText: "Enter Password",
                    hintColor: AppColors.grey,
                    hasSuffixIcon: true,
                    isObscure: true,
                    textEditingController: controller.passwordController,
                  ),
                  Gap(18),
                  CustomInputTextField(
                    hintText: "Confirm Password",
                    hintColor: AppColors.grey,
                    hasSuffixIcon: true,
                    isObscure: true,
                    textEditingController: controller.confirmPasswordController,
                  ),
                  Gap(28),
                  CustomElevatedButton(text: "SIGN UP", onPress: () {}),
                  Gap(38),
                  CustomRichText(
                    text1: "Already have an account? ",
                    text2: "SIGN IN",
                    onPress: () => Get.toNamed(AppRoutes.LOGINSCREEN),
                  ),
                  Gap(38),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
