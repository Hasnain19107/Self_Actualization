import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/Const/app_colors.dart';
import '../controller/bottom_nav_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavController>();

    return Container(
      width: double.infinity,
      height: 100,
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          right: 30,
          bottom: 40,
          left: 30,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(
              controller: controller,
              index: 0,
              activeIcon: Icons.home,
              inactiveIcon: Icons.home_outlined,
              hasInfoIcon: true,
            ),
            _buildNavItem(
              controller: controller,
              index: 1,
              activeIcon: Icons.local_fire_department,
              inactiveIcon: Icons.local_fire_department_outlined,
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
              activeIcon: Icons.music_note,
              inactiveIcon: Icons.music_note_outlined,
            ),
            _buildNavItem(
              controller: controller,
              index: 4,
              activeIcon: Icons.list,
              inactiveIcon: Icons.list_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BottomNavController controller,
    required int index,
    required IconData activeIcon,
    required IconData inactiveIcon,
    bool hasInfoIcon = false,
  }) {
    return Obx(() {
      final isActive = controller.currentIndex.value == index;
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
              Icon(
                isActive ? activeIcon : inactiveIcon,
                color: isActive ? AppColors.white : AppColors.black,
                size: 24,
              ),
              // Info icon overlay (only for home icon when active)
              // Positioned inside the home icon - white 'i' inside white home outline
              if (isActive && hasInfoIcon)
                Positioned(
                  bottom: 8,
                  child: const Text(
                    'i',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
