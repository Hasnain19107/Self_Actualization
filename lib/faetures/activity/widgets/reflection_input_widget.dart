import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/add_reflection_controller.dart';
import '../../../core/const/app_exports.dart';

class ReflectionInputWidget extends StatelessWidget {
  const ReflectionInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddReflectionController>();

    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inputBorderGrey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Text input field
          TextField(
            controller: controller.reflectionController,
            maxLength: controller.maxCharacters,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
              hintText: 'Write about your day...',
              hintStyle: TextStyle(
                color: AppColors.placeholderGrey,
                fontSize: 14,
              ),
              border: InputBorder.none,
              counterText: '', // Hide default counter
            ),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.black,
              height: 1.5,
            ),
          ),
          // Bottom row with mic icon and character counter
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Microphone icon
                Obx(
                  () => GestureDetector(
                    onTap: controller.onMicTap,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: controller.isListening.value
                            ? AppColors.red
                            : AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        controller.isListening.value
                            ? Icons.mic
                            : Icons.mic_none,
                        color: controller.isListening.value
                            ? AppColors.white
                            : AppColors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                // Character counter
                Obx(
                  () => CustomTextWidget(
                    text:
                        '${controller.characterCount.value}/${controller.maxCharacters}',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.mediumGray,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
