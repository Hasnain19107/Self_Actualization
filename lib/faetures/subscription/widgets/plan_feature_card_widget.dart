import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/custom_text_widget.dart';
import '../controller/plan_details_controller.dart';
import '../models/plan_model.dart';

/// Widget to display feature category cards (Self, Social, Safety, Survival)
/// Matches the exact design from Select Level and Category screen
class PlanFeatureCardWidget extends StatelessWidget {
  final PlanCategory category;

  const PlanFeatureCardWidget({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlanDetailsController>();

    return Obx(() {
      final isSelected = controller.selectedCategory.value == category.name;

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: () => controller.onCategoryCardTap(category),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.blue
                  : AppColors.lightBlue,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.blue
                    : AppColors.inputBorderGrey,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    category.emoji ?? '📋',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                Gap(12),
                CustomTextWidget(
                  text: category.name,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: isSelected
                      ? AppColors.white
                      : AppColors.black,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

