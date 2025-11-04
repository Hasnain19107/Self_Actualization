import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../Const/app_colors.dart';
import 'custom_text_widget.dart';

class CustomRichText extends StatelessWidget {
  const CustomRichText({
    super.key,
    required this.text1,
    required this.text2,
    this.onPress,
  });
  final String text1;
  final String text2;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomTextWidget(
          text: text1,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          textColor: AppColors.black,
        ),
        const Gap(6),
        InkWell(
          onTap: onPress,
          child: CustomTextWidget(
            text: text2,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            textColor: AppColors.blue,
          ),
        ),
      ],
    );
  }
}
