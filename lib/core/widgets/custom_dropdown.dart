import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../Const/app_colors.dart';
import '../utils/app_sizes.dart';
import 'custom_text_widget.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String? selectedValue;
  final Function(String?) onChanged;
  final String hintText;
  final String buttonText;
  final bool showButton;
  final bool haveBorders;
  final VoidCallback? onButtonPressed;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    required this.hintText,
    this.showButton = false,
    this.onButtonPressed,
    this.buttonText = "Add New",
    this.haveBorders = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: haveBorders?AppSizes().getWidthPercentage(100):null,
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        border: haveBorders?Border.all(color: AppColors.grey):null,
            borderRadius: BorderRadius.circular(12)
      ),
      child: DropdownButtonHideUnderline(
        child: IntrinsicWidth(
          child: DropdownButton<String>(
            padding: EdgeInsets.zero,
            value: selectedValue,
            hint: CustomTextWidget(
              textAlign: TextAlign.start,
              text: hintText,
              fontSize: 14,
            ),
            icon: Icon(Icons.arrow_drop_down, color: AppColors.brownish),
            onChanged: onChanged,
            items: [
              ...items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: CustomTextWidget(
                    textAlign: TextAlign.start,
                    text: "  $item",
                    fontSize: 14,
                  ),
                );
              }).toList(),
              if (showButton)
                DropdownMenuItem<String>(
                  value: null,
                  enabled: false,
                  child: GestureDetector(
                    onTap: onButtonPressed,
                    child: Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          Icon(Icons.add_circle_outline_sharp,color: AppColors.primaryColor,size: 20,),
                          Gap(8),
                          CustomTextWidget(
                            textAlign: TextAlign.start,
                            text: buttonText,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            textColor: AppColors.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
