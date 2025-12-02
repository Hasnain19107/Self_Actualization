import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/const/app_exports.dart';
import '../../../core/widgets/custom_text_widget.dart';
import '../view/video_player_screen.dart';
import '../../../data/models/learn_and_grow/video_model.dart';

class VideoCardWidget extends StatelessWidget {
  final VideoModel video;

  const VideoCardWidget({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => VideoPlayerScreen(
            videoUrl: video.videoUrl,
            title: video.title,
            description: video.description,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 200,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: video.thumbnailUrl.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(video.thumbnailUrl),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    // Fallback to asset image if network image fails
                  },
                )
              : DecorationImage(
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
                        text: video.formattedDurationMin,
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
                      Icons.play_arrow,
                      size: 32,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),

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
