import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/custom_text_widget.dart';
import '../../../core/utils/app_sizes.dart';
import '../models/plan_model.dart';

/// Widget to display Meta Needs section with list of items
class PlanMetaNeedsSectionWidget extends StatelessWidget {
  final PlanCategory metaNeedsCategory;

  const PlanMetaNeedsSectionWidget({
    super.key,
    required this.metaNeedsCategory,
  });

  @override
  Widget build(BuildContext context) {
    final appSizes = AppSizes();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        CustomTextWidget(
          text: 'Categories included',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          textColor: AppColors.black,
          textAlign: TextAlign.left,
        ),
        Gap(appSizes.getHeightPercentage(2)),
        // Meta Needs Header with emoji/icon
        Container(
          padding: AppSizes().getCustomPadding(),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.blue)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (metaNeedsCategory.emoji != null)
                CustomTextWidget(
                  text:metaNeedsCategory.emoji!,
                  textAlign: TextAlign.start,
                )
              else if (metaNeedsCategory.icon != null)
                Icon(
                  metaNeedsCategory.icon,
                  size: 24,
                  color: AppColors.yellow,
                ),
              Gap(appSizes.getWidthPercentage(2)),
              CustomTextWidget(
                text: metaNeedsCategory.name,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textColor: AppColors.black,
                textAlign: TextAlign.left,
              ),
              Gap(appSizes.getHeightPercentage(2)),
              // Meta Needs Items List
              if (metaNeedsCategory.metaNeedItems != null &&
                  metaNeedsCategory.metaNeedItems!.isNotEmpty)
                ...metaNeedsCategory.metaNeedItems!.map(
                      (item) => Padding(
                    padding: EdgeInsets.only(
                      bottom: appSizes.getHeightPercentage(1.5),
                    ),
                    child: _buildMetaNeedItem(item),
                  ),
                ),
            ],
          ),
        ),

      ],
    );
  }

  /// Build individual meta need item card
  Widget _buildMetaNeedItem(PlanMetaNeedItem item) {
    final appSizes = AppSizes();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: appSizes.getWidthPercentage(2),
        vertical: appSizes.getHeightPercentage(1.5),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CustomTextWidget(
        text: item.description,
        fontSize: 12,
        textOverflow: TextOverflow.visible,
        fontWeight: FontWeight.w400,
        textColor: AppColors.black,
        textAlign: TextAlign.start,
      ),
    );
  }
}