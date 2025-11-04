import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/custom_text_widget.dart';
import '../../home/view/home_screen.dart';
import '../bindings/bottom_nav_binding.dart';
import '../controller/bottom_nav_controller.dart';
import '../widget/bottom_nav_bar.dart';

class MainNavScreen extends StatelessWidget {
  const MainNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize binding when screen is first created
    BottomNavBinding().dependencies();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: _buildBody(),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Widget _buildBody() {
    final controller = Get.find<BottomNavController>();
    return Obx(() {
      switch (controller.currentIndex.value) {
        case 0:
          return const HomeScreen();
        case 1:
          return _buildFlameScreen();
        case 2:
          return _buildTrophyScreen();
        case 3:
          return _buildMusicScreen();
        case 4:
          return _buildListScreen();
        default:
          return const HomeScreen();
      }
    });
  }

  Widget _buildFlameScreen() {
    return const Center(
      child: CustomTextWidget(
        text: 'Flame',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        textColor: Colors.black,
      ),
    );
  }

  Widget _buildTrophyScreen() {
    return const Center(
      child: CustomTextWidget(
        text: 'Trophy',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        textColor: Colors.black,
      ),
    );
  }

  Widget _buildMusicScreen() {
    return const Center(
      child: CustomTextWidget(
        text: 'Music',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        textColor: Colors.black,
      ),
    );
  }

  Widget _buildListScreen() {
    return const Center(
      child: CustomTextWidget(
        text: 'List',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        textColor: Colors.black,
      ),
    );
  }
}
