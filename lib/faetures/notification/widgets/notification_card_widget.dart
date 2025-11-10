import 'package:flutter/material.dart';
import '../../../core/const/app_exports.dart';

class NotificationCardWidget extends StatelessWidget {
  final String message;
  final String timestamp;

  const NotificationCardWidget({
    super.key,
    required this.message,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F7), // Light blue background
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Message text - wraps to next line
          CustomTextWidget(
            text: message,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            textColor: const Color(0xFF2C5F6B), // Dark teal color
            textAlign: TextAlign.left,
            textOverflow: TextOverflow.visible,
          ),
          const SizedBox(height: 8),
          // Timestamp
          CustomTextWidget(
            text: timestamp,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            textColor: const Color(0xFF888888), // Light gray
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
