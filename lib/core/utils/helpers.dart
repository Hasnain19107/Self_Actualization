import 'dart:io';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Const/app_colors.dart';
import '../widgets/custom_text_widget.dart';
import 'app_sizes.dart';

class AppHelpers {
  String formatDate(DateTime date, String format) {
    return DateFormat(format).format(date);
  }

  Future<T?> openBottomSheet<T>(BuildContext context, Widget child) {
    return Get.bottomSheet<T>(
      child,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  AppSizes appSizes = AppSizes();
  final Rx<File?> selectedImage = Rx<File?>(null);

  Future<void> pickImage(
    ImageSource source, {
    Function(File)? onImageSelected,
  }) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      selectedImage.value = file;

      // Call callback if provided
      if (onImageSelected != null) {
        onImageSelected(file);
      }
    }
    Get.back();
  }

  void showImagePickerBottomSheet({Function(File)? onImageSelected}) {
    Get.bottomSheet(
      barrierColor: Colors.transparent,
      SafeArea(
        child: Container(
          width: appSizes.getWidthPercentage(100),
          padding: appSizes.getCustomPadding(),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.brownish2,
                spreadRadius: -1,
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextWidget(
                text: "Select Image Picker Source",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textColor: AppColors.primaryColor,
              ),
              Gap(24),
              GestureDetector(
                onTap: () {
                  pickImage(
                    ImageSource.gallery,
                    onImageSelected: onImageSelected,
                  );
                },
                child: Container(
                  width: appSizes.getWidthPercentage(100),
                  color: AppColors.white,
                  child: CustomTextWidget(
                    text: "Gallery",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Gap(8),
              Divider(color: AppColors.grey, thickness: 0.6),
              Gap(8),
              GestureDetector(
                onTap: () {
                  pickImage(
                    ImageSource.camera,
                    onImageSelected: onImageSelected,
                  );
                },
                child: Container(
                  width: appSizes.getWidthPercentage(100),
                  color: AppColors.white,
                  child: CustomTextWidget(
                    text: "Camera",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Gap(8),
              Divider(color: AppColors.grey, thickness: 0.6),
              Gap(8),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: appSizes.getWidthPercentage(100),
                  color: AppColors.white,
                  child: CustomTextWidget(
                    text: "Cancel",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.grey2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      elevation: 8,
    );
  }

  void clearImage() {
    selectedImage.value = null;
  }

  /// Show time picker and return selected time
  Future<TimeOfDay?> showCustomTimePicker({
    required BuildContext context,
    TimeOfDay? initialTime,
  }) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.grey,
            ),
          ),
          child: child!,
        );
      },
    );
    return picked;
  }
}
