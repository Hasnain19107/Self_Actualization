import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart' as apple;

import '../../../core/const/app_exports.dart';

/// Google + Sign in with Apple as matching circular controls in one row.
class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({
    super.key,
    required this.controller,
    required this.googleButtonText,
    required this.appleButtonText,
  });

  final AuthController controller;
  final String googleButtonText;
  /// Used for accessibility (e.g. "Sign in with Apple" vs "Sign up with Apple").
  final String appleButtonText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: CustomTextWidget(
            text: 'Or continue with',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textColor: AppColors.grey,
          ),
        ),
        const Gap(16),
        FutureBuilder<bool>(
          future: apple.SignInWithApple.isAvailable(),
          builder: (context, snapshot) {
            final appleAvailable = snapshot.data == true;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Obx(
                  () => _CircleSocialButton(
                    semanticLabel: googleButtonText,
                    onTap: controller.isLoading.value
                        ? null
                        : () => controller.signInWithGoogle(),
                    isLoading: controller.isLoading.value,
                    icon: CustomSvgIcon(
                      path: AppImages.google,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                if (appleAvailable) ...[
                  const Gap(20),
                  Obx(
                    () => _CircleSocialButton(
                      semanticLabel: appleButtonText,
                      onTap: controller.isLoading.value
                          ? null
                          : () => controller.signInWithApple(),
                      isLoading: controller.isLoading.value,
                      icon: Icon(
                        Icons.apple,
                        color: AppColors.black,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CircleSocialButton extends StatelessWidget {
  const _CircleSocialButton({
    required this.semanticLabel,
    required this.onTap,
    required this.isLoading,
    required this.icon,
  });

  static const double _size = 56;

  final String semanticLabel;
  final VoidCallback? onTap;
  final bool isLoading;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Opacity(
          opacity: onTap == null ? 0.5 : 1.0,
          child: Container(
            width: _size,
            height: _size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
              border: Border.all(
                color: AppColors.grey,
                width: 1,
              ),
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.blue,
                      ),
                    )
                  : icon,
            ),
          ),
        ),
      ),
    );
  }
}
