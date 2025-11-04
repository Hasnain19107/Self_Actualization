import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../binding/home_binding.dart';
import '../controller/home_controller.dart';
import '../widgtes/action_cards_widget.dart';
import '../widgtes/header_widget.dart';
import '../widgtes/needs_slider_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize binding
    HomeBinding().dependencies();
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            HeaderWidget(
              userName: controller.userName.value,
              greeting: controller.greeting.value,
            ),
            // Action Cards
            ActionCardsWidget(
              actionCards: controller.actionCards,
              onTap: controller.onActionCardTap,
            ),
            const SizedBox(height: 24),
            // Needs Sliders
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: controller.needs
                      .map((need) => NeedsSliderWidget(need: need))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
