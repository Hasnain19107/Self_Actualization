import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';

class YourActivityController extends GetxController {
  final RxString selectedDate = 'Today, 2 Apr'.obs;
  final List<String> dates = ['30', '31', '1', 'Today, 2 Apr', '3', '4', '5'];

  void selectDate(String date) {
    selectedDate.value = date;
  }

  final List<Map<String, dynamic>> activityCardsData = [
    {
      'icon1': Icons.flash_on,
      'icon1Color': Colors.orange,
      'icon2': Icons.star_border,
      'icon2Color': Colors.grey,
      'title': 'Focus Streak',
      'subtitle': '7 Days',
    },
    {
      'icon1': Icons.sentiment_satisfied_alt,
      'icon1Color': Colors.yellow,
      'icon2': Icons.add,
      'icon2Color': Colors.white,
      'icon2BgColor': Colors.blue,
      'title': 'Daily Reflection & Journaling',
      'subtitle': '', // No subtitle for this card
    },
  ];

  final List<Map<String, dynamic>> goalsData = [
    {
      'barColor': const Color(0xFFD3E85D),
      'title': '8h Work Target',
      'subtitle': 'Personal',
    },
    {
      'barColor': const Color(0xFF7AC4E6),
      'title': 'Achieve 6.5h Sleep',
      'subtitle': 'Health',
    },
    {
      'barColor': const Color(0xFFE9C6F2),
      'title': '100 Calories Burn',
      'subtitle': 'Health',
    },
  ];

  final List<Map<String, dynamic>> moodEmojisData = [
    {
      'day': 'Mon',
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
}
