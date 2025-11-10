import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../binding/add_reflection_binding.dart';
import '../controller/add_reflection_controller.dart';
import '../widgets/mood_selector_widget.dart';
import '../widgets/reflection_input_widget.dart';
import '../../../core/const/app_exports.dart';

class AddReflectionScreen extends StatelessWidget {
  AddReflectionScreen({super.key});

  final AppSizes appSizes = AppSizes();

  @override
  Widget build(BuildContext context) {
    AddReflectionBinding().dependencies();
    final controller = Get.find<AddReflectionController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appSizes.getWidthPercentage(3),
            vertical: appSizes.getHeightPercentage(2),
          ),

          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with back button and title

                      // Back button
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.inputBorderGrey,
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.black,
                            size: 20,
                          ),
                        ),
                      ),
                      Gap(20),
                      CustomTextWidget(
                        text: 'Daily Reflection & Journaling',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.black,
                        textAlign: TextAlign.center,
                      ),

                      // Spacer to center the title
                      const Gap(32),

                      // Today's Reflection Section
                      CustomTextWidget(
                        text: "Today's Reflection",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.black,
                        textAlign: TextAlign.left,
                      ),
                      const Gap(16),

                      // Mood Selector
                      const MoodSelectorWidget(),
                      const Gap(32),

                      // Reflection Input Field
                      const ReflectionInputWidget(),
                    ],
                  ),
                ),
              ),
              // Save Button - Fixed at bottom
              Padding(
                padding: EdgeInsets.only(
                  bottom: appSizes.getHeightPercentage(2),
                ),
                child: CustomElevatedButton(
                  text: 'Save',
                  onPress: controller.saveReflection,
                  backgroundColor: AppColors.blue,
                  textColor: AppColors.white,
                  borderRadius: 1000,
                  height: 56,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
