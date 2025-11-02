import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../Const/app_colors.dart';
import '../utils/app_sizes.dart';
import 'custom_text_widget.dart';

class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton({
    super.key,
    required this.onPress,
    this.text = '',
    this.svgIconPath,
    this.height = 56,
    this.width = double.infinity,
    this.borderRadius = 16,
    this.backgroundColor = AppColors.primaryColor,
    this.textColor = AppColors.white,
    this.isLoading = false,
    this.textSize = 16,
    this.iconSize = 12,
    this.centerSvgOnly = false,
    this.bottomOnlyElevation = false,
    this.textFontWeight = FontWeight.w600,
    this.padding = const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    this.hasRightIcon = false,
    this.borderColor, this.iconColor,
  });

  final VoidCallback onPress;
  final String text;
  final Color? iconColor;
  final Color? borderColor;
  final bool hasRightIcon;
  final String? svgIconPath;
  final double height;
  final double width;
  final double borderRadius;
  final FontWeight textFontWeight;
  final double textSize;
  final double iconSize;
  final bool isLoading;
  final EdgeInsetsGeometry padding;
  final bool centerSvgOnly;
  final bool bottomOnlyElevation;
  final Color backgroundColor;
  final Color textColor;

  final AppSizes appSizes = AppSizes();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPress,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
          boxShadow: bottomOnlyElevation
              ? [
                  BoxShadow(
                    color: AppColors.brown,
                    offset: Offset(0, 4),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        padding: padding,
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2,
                  ),
                )
              : buildContent(),
        ),
      ),
    );
  }

  Widget buildContent() {
    if (centerSvgOnly && svgIconPath != null) {
      return buildImage(svgIconPath!, iconSize, iconSize,iconColor);
    }

    return Row(
      mainAxisAlignment: hasRightIcon
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      children: [
        if (svgIconPath != null && !hasRightIcon)
          Gap(appSizes.getWidthPercentage(11))
        else
          const Spacer(),
        if (hasRightIcon) ...[
          buildImage(svgIconPath!, iconSize, iconSize,iconColor),
          Gap(6),
        ],
        CustomTextWidget(
          text: text,
          textColor: textColor,
          fontWeight: textFontWeight,
          fontSize: textSize,
        ),

        if (svgIconPath != null && !hasRightIcon)
          Container(
            padding: EdgeInsets.all(12),
            height: height,
            width: height,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: buildImage(svgIconPath!, iconSize, iconSize,iconColor),
          )
        else
          const Spacer(),
      ],
    );
  }

  Widget buildImage(String path, double height, double width, Color? iconColor) {
      return Image.asset(
        path,
        height: height,
        width: width,
        fit: BoxFit.contain,
      );
  }
}
