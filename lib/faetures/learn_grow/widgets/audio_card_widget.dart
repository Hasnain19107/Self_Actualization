import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/learn_grow_controller.dart';
import '../../../core/const/app_exports.dart';
import '../../../data/models/audio/audio_model.dart';

class AudioCardWidget extends StatelessWidget {
  final AudioModel audio;

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
                    controller.getEmojiForCategory(audio.category),
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
              Obx(() => Container(
                    width: 66,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        '${controller.getAudioCurrentTime(audio.id)}/${controller.getAudioTotalDuration(audio.id)}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: isSelected ? AppColors.white : AppColors.black,
                        ),
                      ),
                    ),
                  )),
              const SizedBox(width: 12),
              // Play/Pause icon
              Obx(() => Icon(
                    controller.isAudioPlaying(audio.id) ? Icons.pause : Icons.play_arrow,
                    color: isSelected ? AppColors.white : AppColors.black,
                    size: 24,
                  )),
            ],
          ),
        ),
      );
    });
  }
}
