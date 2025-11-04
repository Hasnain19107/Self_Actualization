import 'package:flutter/material.dart';
import '../../../core/Const/app_colors.dart';
import '../../../core/widgets/custom_text_widget.dart';

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                text: 'Actions',
                fontSize: 18,
                fontWeight: FontWeight.w700,
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
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: actionCards.asMap().entries.map((entry) {
              final card = entry.value;
              final isLast = entry.key == actionCards.length - 1;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(card['title']),
                  child: Container(
                    margin: EdgeInsets.only(right: isLast ? 0 : 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        // Emoji icon in white circle at top-left
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                card['emoji'] ?? '',
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        ),
                        // Text centered below
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: CustomTextWidget(
                              text: card['title'],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              textColor: AppColors.black,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
