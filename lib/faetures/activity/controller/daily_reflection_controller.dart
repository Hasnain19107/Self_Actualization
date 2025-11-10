import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';

class DailyReflectionController extends GetxController {
  // Mood data for the mood section
  final List<Map<String, dynamic>> moodData = [
    {
      'day': 'History',
      'imagePath': AppImages.sleepEmoji,
      'bgColor': const Color(0xFFFFB74D),
    }, // Orange
    {
      'day': 'Tue',
      'imagePath': AppImages.teethEmoji,
      'bgColor': const Color(0xFFFFEE58),
    }, // Yellow
    {
      'day': 'Wed',
      'imagePath': AppImages.silentEmoji,
      'bgColor': const Color(0xFF81D4FA),
    }, // Light Blue
    {
      'day': 'Thr',
      'imagePath': AppImages.wonderEmoji,
      'bgColor': const Color(0xFFF8BBD0),
    }, // Light Pink
    {
      'day': 'Fri',
      'imagePath': AppImages.hardEmoji,
      'bgColor': const Color(0xFF42A5F5),
    }, // Dark Blue
    {
      'day': 'Sat',
      'imagePath': AppImages.happyEmoji,
      'bgColor': const Color(0xFFFFEE58),
    }, // Yellow
    {
      'day': 'Sun',
      'imagePath': AppImages.happyEmoji,
      'bgColor': const Color(0xFFFFEE58),
    }, // Yellow
  ];

  // Reflection entries data
  final RxList<Map<String, dynamic>> reflections = <Map<String, dynamic>>[
    {
      'id': '1',
      'text':
          'Et aliquid deleniti et. Aliquam aspernatur necessitatibus qui. Explicabo itaque odio voluptatem dolorum.',
      'date': '20/10/25',
    },
    {
      'id': '2',
      'text':
          'Aut sint aut aut. Soluta ratione molestiae blanditiis soluta nam voluptatem repellendus dolor. Impedit et et quis fuga est et animi accusamus. Nemo quis fugit ab cum consequatur. Libero magnam velit qui aperiam nesciunt aspernatur nisi amet rerum.',
      'date': '20/10/25',
    },
    {
      'id': '3',
      'text':
          'Et iusto sit. Ex sit dolor optio laboriosam ut architecto voluptas aut. Enim impedit aut a',
      'date': '20/10/25',
    },
  ].obs;

  void addNewReflection() {
    Get.toNamed(AppRoutes.addReflectionScreen);
  }

  void viewReflectionHistory() {
    // Handle view full history
    ToastClass.showCustomToast('View full reflection history', type: ToastType.simple);
  }
}
