import 'package:flutter/material.dart';
import '../../../core/const/app_exports.dart';

class ProfileSectionTitleWidget extends StatelessWidget {
  final String title;

  const ProfileSectionTitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextWidget(
      text: title,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      textColor: AppColors.black,
      textAlign: TextAlign.left,
    );
  }
}

