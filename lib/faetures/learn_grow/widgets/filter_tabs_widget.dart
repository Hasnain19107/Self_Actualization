import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/learn_grow_controller.dart';
import '../../../core/const/app_exports.dart';

class FilterTabsWidget extends StatelessWidget {
  const FilterTabsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LearnGrowController>();

    return Obx(
      () => Row(
        children: controller.filterTabs.asMap().entries.map((entry) {
          final tab = entry.value;
          final isLast = entry.key == controller.filterTabs.length - 1;
          final isSelected = controller.selectedTab.value == tab['name'];
          return GestureDetector(
            onTap: () => controller.selectTab(tab['name']),
            child: Container(
              width: 100,
              height: 28,
              margin: EdgeInsets.only(right: isLast ? 0 : 10),
              padding: const EdgeInsets.only(
                top: 5,
                right: 10,
                bottom: 5,
                left: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.lightBlue : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.blue
                      : AppColors.inputBorderGrey,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    tab['icon'],
                    size: 14,
                    color: isSelected ? AppColors.blue : AppColors.black,
                  ),
                  const SizedBox(width: 6),
                  CustomTextWidget(
                    text: tab['name'],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    textColor: isSelected ? AppColors.blue : AppColors.black,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
