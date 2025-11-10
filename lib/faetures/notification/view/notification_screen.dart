import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../binding/notification_binding.dart';
import '../controller/notification_controller.dart';
import '../widgets/notification_card_widget.dart';
import '../widgets/notification_header_widget.dart';
import '../../../core/const/app_exports.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationBinding().dependencies();
    final controller = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Light gray background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back button and title
            const NotificationHeaderWidget(),
            const Gap(24),

            // Notification List
            Expanded(
              child: Obx(
                () => ListView.separated(
                  itemCount: controller.notifications.length,
                  separatorBuilder: (context, index) => Container(
                    height: 1,
                    color: const Color(0xFFEFEFEF), // Separator line color
                  ),
                  itemBuilder: (context, index) {
                    final notification = controller.notifications[index];
                    return NotificationCardWidget(
                      message: notification['message'],
                      timestamp: notification['timestamp'],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
