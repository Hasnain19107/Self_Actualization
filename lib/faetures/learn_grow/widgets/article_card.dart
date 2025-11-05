import 'package:flutter/material.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/const/app_images.dart';
import '../../../core/widgets/custom_text_widget.dart';
import '../../home/controller/learn_grow_controller.dart';

class ArticleCardWidget extends StatelessWidget {
  final VideoFile video;

  const ArticleCardWidget({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle video tap
      },
      child: Container(
        width: double.infinity,
        height: 128,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(AppImages.videocardimage),
            fit: BoxFit.cover,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // ✅ Gradient overlay directly on top of image
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

              // Duration badge (top right)
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
                        text: 'Read Time: ${video.duration}',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.mediumGray,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Play button (center)

              // Title & description at bottom with dark gradient
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
                        text: video.title,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.black,
                      ),
                      const SizedBox(height: 8),
                      CustomTextWidget(
                        text: video.description,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textColor: AppColors.black,
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
