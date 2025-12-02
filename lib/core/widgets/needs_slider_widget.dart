import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../const/app_exports.dart';
import '../models/need_data.dart';

class NeedsSliderWidget extends StatelessWidget {
  final NeedData need;
  final ValueChanged<double>? onVChanged;
  final ValueChanged<double>? onQChanged;

  const NeedsSliderWidget({
    super.key,
    required this.need,
    this.onVChanged,
    this.onQChanged,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController? homeController =
        Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;

    final ValueChanged<double> vHandler = onVChanged ??
        (homeController != null
            ? (value) => homeController.updateVValue(need.id, value)
            : (value) => need.vValue.value = value);

    final ValueChanged<double> qHandler = onQChanged ??
        (homeController != null
            ? (value) => homeController.updateQValue(need.id, value)
            : (value) => need.qValue.value = value);

    return Container(
      width: double.infinity,
      height: 120,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.only(top: 5, right: 10, left: 10),
      decoration: BoxDecoration(
        color: AppColors.darkwhite,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top: 0 and 10 labels
          const SizedBox(height: 8),
          // Progress bar - adapt color based on average V/Q
       Obx(() {
  final averageValue =
      ((need.vValue.value + need.qValue.value) / 2).clamp(0.0, 10.0);
  final fillColor = _getSliderColor(averageValue);
  final widthFactor = (averageValue / 10).clamp(0.0, 1.0);

  return Container(
    height: 12,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          // un-progress background
          Container(color: Colors.white),

          // progress
          FractionallySizedBox(
            widthFactor: widthFactor == 0 ? 0.001 : widthFactor,
            alignment: Alignment.centerLeft,
            child: Container(color: fillColor),
          ),
        ],
      ),
    ),
  );
}),

          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                text: '0',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textColor: AppColors.black,
                textAlign: TextAlign.left,
              ),
              Center(
                child: CustomTextWidget(
                  text: need.title,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.black,
                  textAlign: TextAlign.center,
                ),
              ),
              CustomTextWidget(
                text: '10',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textColor: AppColors.black,
                textAlign: TextAlign.right,
              ),
            ],
          ),

          const Gap(16),
          // V and Q Sliders in same row
          Row(
            children: [
              // V Slider
              SizedBox(
                width: 152.52,
                child: _buildVerticalSlider(
                  label: 'V',
                  value: need.vValue,
                  onChanged: vHandler,
                ),
              ),
              const SizedBox(width: 10),
              // Q Slider
              SizedBox(
                width: 152.52,
                child: _buildVerticalSlider(
                  label: 'Q',
                  value: need.qValue,
                  onChanged: qHandler,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalSlider({
    required String label,
    required RxDouble value,
    required ValueChanged<double> onChanged,
  }) {
    return Obx(
      () => Column(
        children: [
          // Slider track with filled portion (static, display-only)
          SizedBox(
            height: 16,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Light blue track background
                Container(
                  width: 152.52,
                  height: 16,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      // Light blue filled portion (upper progress) - static based on API data
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        width: (value.value / 10) * (152.52 - 4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.lightBlue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Blue circular thumb (16x16) - static, no interaction
                Positioned(
                  left: (value.value / 10) * 152.52 - 8,
                  top: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: AppColors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Label below thumb - positioned at thumb location
          SizedBox(
            height: 20,
            child: Stack(
              children: [
                Positioned(
                  left: (value.value / 10) * 152.52 - 0,
                  child: CustomTextWidget(
                    text: label,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    textColor: AppColors.black,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getSliderColor(double currentValue) {
    return currentValue > 5 ? AppColors.greenAccent : AppColors.red;
  }
}
