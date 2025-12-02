import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/const/app_exports.dart';
import '../../../core/widgets/custom_text_widget.dart';
import '../view/article_view_screen.dart';
import '../../../data/models/learn_and_grow/article_model.dart';

class ArticleCardWidget extends StatelessWidget {
  final ArticleModel article;

  const ArticleCardWidget({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ArticleViewScreen(
            title: article.title,
            content: article.content,
            thumbnailUrl: article.thumbnailUrl,
            readTimeMinutes: article.readTimeMinutes,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 200,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: article.thumbnailUrl.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(article.thumbnailUrl),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    // Fallback handled in errorBuilder
                  },
                )
              : null,
          color: article.thumbnailUrl.isEmpty ? AppColors.lightGray : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.videoOverlay70.withOpacity(0.7),
                      AppColors.videoOverlay30.withOpacity(0.3),
                    ],
                  ),
                ),
              ),

              // Read time badge (top right)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.mediumGray,
                      ),
                      const SizedBox(width: 4),
                      CustomTextWidget(
                        text: '${article.readTimeMinutes} min',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.mediumGray,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Article icon (center if no thumbnail)
              if (article.thumbnailUrl.isEmpty)
                Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.article,
                        size: 32,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),

              // Title & description at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                        text: article.title,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.white,
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      CustomTextWidget(
                        text: 'Tap to read full article',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        textColor: AppColors.white.withOpacity(0.8),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
