import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/bottom_nav_controller.dart';
import '../../../core/const/app_exports.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int? initialIndex;

  const CustomBottomNavBar({super.key, this.initialIndex});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavController>();

    // Set initial index if provided
    if (initialIndex != null && controller.currentIndex.value != initialIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.changeIndex(initialIndex!);
      });
    }

    return SafeArea(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: AppColors.white),
        child: Padding(
          padding: const EdgeInsets.only(left: 12,right: 12,bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                controller: controller,
                index: 0,
                activeIcon: AppImages.homeIcon,
                inactiveIcon: AppImages.homeIcon,
                hasInfoIcon: true,
              ),
              _buildNavItem(
                controller: controller,
                index: 1,
                activeIcon: AppImages.activityIcon,
                inactiveIcon: AppImages.activityIcon,
              ),
              _buildNavItem(
                controller: controller,
                index: 2,
                activeIcon: Icons.emoji_events,
                inactiveIcon: Icons.emoji_events_outlined,
              ),
              _buildNavItem(
                controller: controller,
                index: 3,
                activeIcon: Icons.person,
                inactiveIcon: Icons.person_outline,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BottomNavController controller,
    required int index,
    dynamic activeIcon,
    dynamic inactiveIcon,
    bool hasInfoIcon = false,
  }) {
    return Obx(() {
      final isActive = controller.currentIndex.value == index;
      final icon = isActive ? activeIcon : inactiveIcon;

      Widget iconWidget;
      if (icon is String) {
        // It's an image path (PNG)
        iconWidget = ColorFiltered(
          colorFilter: ColorFilter.mode(
            isActive ? AppColors.white : AppColors.black,
            BlendMode.srcIn,
          ),
          child: Image.asset(
            icon,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox.shrink();
            },
          ),
        );
      } else if (icon is IconData) {
        // It's an IconData
        iconWidget = Icon(
          icon,
          color: isActive ? AppColors.white : AppColors.black,
          size: 24,
        );
      } else {
        // Fallback
        iconWidget = const SizedBox.shrink();
      }

      return GestureDetector(
        onTap: () => controller.changeIndex(index),
        child: Container(
          width: 48,
          height: 48,
          decoration: isActive
              ? BoxDecoration(
                  color: AppColors.blue,
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.blue.withOpacity(0.9), AppColors.blue],
                  ),
                )
              : null,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Main icon
              iconWidget,

              // Info icon overlay (only for home icon when active)
              // Positioned inside the home icon - white 'i' inside white home outline
            ],
          ),
        ),
      );
    });
  }
}
