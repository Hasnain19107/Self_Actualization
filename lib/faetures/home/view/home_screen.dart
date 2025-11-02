import 'package:flutter/material.dart';
import '../../../core/const/app_colors.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController locationController = TextEditingController(text: 'USA-New York');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
    );
  }
}