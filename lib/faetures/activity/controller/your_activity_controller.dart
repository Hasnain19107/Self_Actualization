import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      'barColor': Colors.green,
      'title': '8h Work Target',
      'subtitle': 'Personal',
    },
    {
      'barColor': Colors.blue,
      'title': 'Achieve 6.5h Sleep',
      'subtitle': 'Health',
    },
    {
      'barColor': Colors.pink,
      'title': '100 Calories Burn',
      'subtitle': 'Health',
    },
  ];

  final List<Map<String, dynamic>> moodEmojisData = [
    {'day': 'Mon', 'emoji': '😴', 'bgColor': const Color(0xFFFFB74D)}, // Orange
    {'day': 'Tue', 'emoji': '😬', 'bgColor': const Color(0xFFFFEE58)}, // Yellow
    {
      'day': 'Wed',
      'emoji': '😐',
      'bgColor': const Color(0xFF81D4FA),
    }, // Light Blue
    {
      'day': 'Thr',
      'emoji': '😅',
      'bgColor': const Color(0xFFF8BBD0),
    }, // Light Pink
    {
      'day': 'Fri',
      'emoji': '😑',
      'bgColor': const Color(0xFF42A5F5),
    }, // Dark Blue
    {'day': 'Sat', 'emoji': '😂', 'bgColor': const Color(0xFFFFEE58)}, // Yellow
    {'day': 'Sun', 'emoji': '😂', 'bgColor': const Color(0xFFFFEE58)}, // Yellow
  ];
}
