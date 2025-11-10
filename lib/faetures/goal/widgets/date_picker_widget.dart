import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';

class DatePickerWidget extends StatelessWidget {
  final String label;
  final RxString dateValue;
  final VoidCallback onTap;

  const DatePickerWidget({
    super.key,
    required this.label,
    required this.dateValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            text: label,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textColor: AppColors.black,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 8),
          Obx(
            () => GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.inputBorderGrey,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        dateValue.value.isEmpty ? 'DD/MM/YY' : dateValue.value,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: dateValue.value.isEmpty
                              ? AppColors.placeholderGrey
                              : AppColors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: AppColors.mediumGray,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
