import 'package:flutter/material.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/custom_text_widget.dart';

class MoodEmojiWidget extends StatelessWidget {
  final String day;
  final String emoji;
  final Color backgroundColor;

  const MoodEmojiWidget({
    super.key,
    required this.day,
    required this.emoji,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(height: 4),
        CustomTextWidget(
          text: day,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          textColor: AppColors.black,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
