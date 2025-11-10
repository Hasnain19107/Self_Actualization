import 'package:flutter/material.dart';
import '../const/app_colors.dart';
import 'custom_text_widget.dart';

class MoodEmojiWidget extends StatelessWidget {
  final String day;
  final String? emoji; // Optional for backward compatibility
  final String? imagePath; // Image path from assets

  const MoodEmojiWidget({
    super.key,
    required this.day,
    this.emoji,
    this.imagePath,
  }) : assert(
         emoji != null || imagePath != null,
         'Either emoji or imagePath must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: imagePath != null && imagePath!.isNotEmpty
                ? Image.asset(
                    imagePath!,
                    width: 34,
                    height: 32,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to emoji if image fails to load
                      return emoji != null
                          ? Text(emoji!, style: const TextStyle(fontSize: 18))
                          : const SizedBox.shrink();
                    },
                  )
                : emoji != null
                ? Text(emoji!, style: const TextStyle(fontSize: 18))
                : const SizedBox.shrink(),
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
