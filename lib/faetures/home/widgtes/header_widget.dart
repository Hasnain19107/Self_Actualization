import 'package:flutter/material.dart';
import '../../../core/Const/app_colors.dart';
import '../../../core/widgets/custom_text_widget.dart';

class HeaderWidget extends StatelessWidget {
  final String userName;
  final String greeting;

  const HeaderWidget({
    super.key,
    required this.userName,
    required this.greeting,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // User profile section
          Expanded(
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.lightGray,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 30,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(width: 12),
                // Greeting
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextWidget(
                        text: '$greeting $userName',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textColor: AppColors.black,
                        textAlign: TextAlign.left,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      const Text('☀️', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Notification bell
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.black,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
