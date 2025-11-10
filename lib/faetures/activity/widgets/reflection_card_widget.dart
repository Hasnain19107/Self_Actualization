import 'package:flutter/material.dart';
import '../../../core/const/app_exports.dart';

class ReflectionCardWidget extends StatelessWidget {
  final String text;
  final String date;

  const ReflectionCardWidget({
    super.key,
    required this.text,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Text content - expands to fill space
          Padding(
            padding: const EdgeInsets.only(
              right: 64,
            ), // Space for date container (54) + gap (10)
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
                height: 1.5,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          // Date positioned at top-right
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 54,
              height: 19,
              margin: const EdgeInsets.only(left: 10), // gap: 10px
              padding: const EdgeInsets.only(
                top: 2,
                right: 5,
                bottom: 2,
                left: 5,
              ),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  date,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
