import 'package:flutter/material.dart';
import '../../../core/const/app_exports.dart';

class ProfileFocusAreasWidget extends StatelessWidget {
  final List<String> focusAreas;

  const ProfileFocusAreasWidget({
    super.key,
    required this.focusAreas,
  });

  @override
  Widget build(BuildContext context) {
    if (focusAreas.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: focusAreas.map((area) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: AppColors.lightBlue.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.lightBlue,
              width: 1,
            ),
          ),
          child: CustomTextWidget(
            text: area,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            textColor: AppColors.black,
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }
}

