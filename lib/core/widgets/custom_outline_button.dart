import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../Const/app_colors.dart';
import '../utils/app_sizes.dart';
import 'custom_text_widget.dart';

class CustomOutlineButton extends StatelessWidget {
   CustomOutlineButton({
    super.key,
    required this.onPress,
    required this.text,
    this.height = 56,
    this.width = double.infinity,
    this.borderColor = AppColors.grey,
    this.borderRadius = 16,
    this.textColor = AppColors.black,
     required this.iconPath,
  });

  final Color textColor;
  final String iconPath;
  final VoidCallback onPress;
  final String text;
  final double height;
  final double width;
  final Color borderColor;
  final double borderRadius;
  final AppSizes appSizes = AppSizes();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: height,
          width: width,
          child: OutlinedButton(
            onPressed: onPress,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: borderColor,
                width: 0.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset( iconPath),
                Gap(8),
                CustomTextWidget(
                  text: text,
                  fontSize:15,
                  textColor: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
