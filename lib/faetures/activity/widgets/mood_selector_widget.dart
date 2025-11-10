import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/add_reflection_controller.dart';
import '../../../core/const/app_exports.dart';

class MoodSelectorWidget extends StatelessWidget {
  const MoodSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddReflectionController>();

    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: controller.moodOptions.asMap().entries.map((entry) {
          final index = entry.key;
          final mood = entry.value;
          final imagePath = mood['imagePath'] as String?;
          final isSelected = controller.selectedMood.value == imagePath;

          return GestureDetector(
            onTap: () => controller.selectMood(index),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: isSelected
                    ? Border.all(color: AppColors.blue, width: 2)
                    : null,
              ),
              child: Center(
                child: imagePath != null && imagePath.isNotEmpty
                    ? Image.asset(
                        imagePath,
                        width: 34,
                        height: 32,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox.shrink();
                        },
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
