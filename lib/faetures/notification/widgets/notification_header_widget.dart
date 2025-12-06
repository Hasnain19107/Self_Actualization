import 'package:flutter/material.dart';
import '../../../core/const/app_exports.dart';

class NotificationHeaderWidget extends StatelessWidget {
  const NotificationHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomTextWidget(
        text: 'Notifications',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        textColor: AppColors.black,
        textAlign: TextAlign.left,
      ),
    );
  }
}
