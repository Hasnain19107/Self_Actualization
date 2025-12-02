import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';

class ArticleViewScreen extends StatelessWidget {
  final String title;
  final String content;
  final String thumbnailUrl;
  final int readTimeMinutes;

  const ArticleViewScreen({
    super.key,
    required this.title,
    required this.content,
    required this.thumbnailUrl,
    required this.readTimeMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.black,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextWidget(
                      text: 'Article',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      textColor: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Article content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thumbnail image
                    if (thumbnailUrl.isNotEmpty)
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                        ),
                        child: Image.network(
                          thumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.lightGray,
                              child: const Icon(
                                Icons.article,
                                size: 64,
                                color: AppColors.mediumGray,
                              ),
                            );
                          },
                        ),
                      ),

                    // Article details
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          CustomTextWidget(
                            text: title,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            textColor: AppColors.black,
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 16),

                          // Read time
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: AppColors.mediumGray,
                              ),
                              const SizedBox(width: 8),
                              CustomTextWidget(
                                text: '$readTimeMinutes min read',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                textColor: AppColors.mediumGray,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Divider
                          Divider(
                            color: AppColors.inputBorderGrey,
                            thickness: 1,
                          ),
                          const SizedBox(height: 24),

                          // Content
                          Text(
                            content,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black,
                              fontFamily: 'Poppins',
                              height: 1.6,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

