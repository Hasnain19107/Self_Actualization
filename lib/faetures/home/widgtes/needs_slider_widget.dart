import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/Const/app_colors.dart';
import '../../../core/widgets/custom_text_widget.dart';
import '../controller/home_controller.dart';

class NeedsSliderWidget extends StatelessWidget {
  final NeedData need;

  const NeedsSliderWidget({super.key, required this.need});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 82,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.only(top: 5, right: 10, bottom: 5, left: 10),
      decoration: BoxDecoration(
        color: AppColors.lightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top: 0 and 10 labels
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
              CustomTextWidget(
                text: '10',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textColor: AppColors.black,
                textAlign: TextAlign.right,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Green progress bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.75, // 75% filled
              child: Container(
                decoration: BoxDecoration(
                  color: need.isGreen ? AppColors.green : AppColors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Title
          Center(
            child: CustomTextWidget(
              text: need.title,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              textColor: AppColors.black,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          // V and Q Sliders in same row
          Row(
            children: [
              // V Slider
              SizedBox(
                width: 152.52,
                child: _buildVerticalSlider(
                  label: 'V',
                  value: need.vValue,
                  onChanged: (value) {
                    Get.find<HomeController>().updateVValue(need.id, value);
                  },
                ),
              ),
              const SizedBox(width: 10),
              // Q Slider
              SizedBox(
                width: 152.52,
                child: _buildVerticalSlider(
                  label: 'Q',
                  value: need.qValue,
                  onChanged: (value) {
                    Get.find<HomeController>().updateQValue(need.id, value);
                  },
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
    required Function(double) onChanged,
  }) {
    return Obx(
      () => Column(
        children: [
          // Slider track with filled portion
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
                      // Light blue filled portion (upper progress)
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
                // Blue circular thumb (16x16) - stacked over the slider
                Positioned(
                  left: (value.value / 10) * 152.52 - 8,
                  top: 0,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      final trackWidth = 152.52;
                      final newValue =
                          (details.localPosition.dx / trackWidth) * 10;
                      onChanged(newValue.clamp(0.0, 10.0));
                    },
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppColors.blue,
                        shape: BoxShape.circle,
                      ),
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
                  left: (value.value / 10) * 152.52 - 6,
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
}
