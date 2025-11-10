import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/const/app_exports.dart';

class ActivityCardWidget extends StatelessWidget {
  final IconData icon1;
  final Color icon1Color;
  final IconData? icon2;
  final Color? icon2Color;
  final Color? icon2BgColor;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const ActivityCardWidget({
    super.key,
    required this.icon1,
    required this.icon1Color,
    this.icon2,
    this.icon2Color,
    this.icon2BgColor,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon1, color: icon1Color, size: 24),
                if (icon2 != null)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: icon2BgColor ?? Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon2,
                      color: icon2Color ?? AppColors.black,
                      size: 16,
                    ),
                  ),
              ],
            ),
            const Gap(16),
            CustomTextWidget(
              text: title,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              textColor: AppColors.black,
              textAlign: TextAlign.left,
            ),
            if (subtitle.isNotEmpty) ...[
              const Gap(4),
              CustomTextWidget(
                text: subtitle,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                textColor: AppColors.black,
                textAlign: TextAlign.left,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
