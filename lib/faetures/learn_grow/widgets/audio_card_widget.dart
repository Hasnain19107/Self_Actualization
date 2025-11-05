import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/custom_text_widget.dart';
import '../controller/learn_grow_controller.dart';

class AudioCardWidget extends StatelessWidget {
  final AudioFile audio;

  const AudioCardWidget({super.key, required this.audio});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LearnGrowController>();

    return Obx(() {
      final isSelected = controller.selectedAudioId.value == audio.id;
      return GestureDetector(
        onTap: () => controller.toggleAudio(audio.id),
        child: Container(
          width: double.infinity,
          height: 54,
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.blue : AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.blue : AppColors.inputBorderGrey,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Emoji
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    audio.emoji,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Title
              Expanded(
                child: CustomTextWidget(
                  text: audio.title,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textColor: isSelected ? AppColors.white : AppColors.black,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(width: 12),
              // Time and duration
              Container(
                width: 66,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    '${audio.currentTime}/${audio.totalDuration}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Pause/Play icon
              Icon(
                audio.isPlaying.value ? Icons.pause : Icons.pause_outlined,
                color: isSelected ? AppColors.white : AppColors.black,
                size: 24,
              ),
            ],
          ),
        ),
      );
    });
  }
}
