import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/const/app_exports.dart';

class ActionCardsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> actionCards;
  final Function(String) onTap;

  const ActionCardsWidget({
    super.key,
    required this.actionCards,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextWidget(
              text: 'Actions',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textColor: AppColors.black,
              textAlign: TextAlign.left,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: AppColors.black),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),

        Row(
          children: actionCards.asMap().entries.map((entry) {
            final card = entry.value;
            final isLast = entry.key == actionCards.length - 1;
            return GestureDetector(
              onTap: () => onTap(card['title']),
              child: Container(
                margin: EdgeInsets.only(right: isLast ? 0 : 6),
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                  left: 10,
                  right: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Emoji icon in white circle at top
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          card['emoji'] ?? '',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Text - will expand container width
                    CustomTextWidget(
                      text: card['title'],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.black,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
