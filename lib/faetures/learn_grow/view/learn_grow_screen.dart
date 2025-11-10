import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../controller/learn_grow_controller.dart';
import '../widgets/article_card.dart';
import '../widgets/audio_card_widget.dart';
import '../widgets/filter_tabs_widget.dart';
import '../widgets/video_card_widget.dart';
import '../../../core/const/app_exports.dart';

class LearnGrowScreen extends StatelessWidget {
  LearnGrowScreen({super.key});

  final AppSizes appSizes = AppSizes();
  final searchController = Get.put(TextEditingController());

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(LearnGrowController());

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appSizes.getWidthPercentage(3),
            vertical: appSizes.getHeightPercentage(2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button and title

              // Back button
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.inputBorderGrey,
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.black,
                    size: 20,
                  ),
                ),
              ),
              const Gap(24),
              // Title
              const CustomTextWidget(
                text: 'Learn & Grow',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                textColor: AppColors.black,
                textAlign: TextAlign.left,
              ),

              const SizedBox(height: 20),
              // Search bar
              SearchBarWidget(
                searchController: searchController,
                onChanged: (value) {
                  // Handle search
                },
                onMicTap: () {
                  // Handle mic tap
                },
              ),
              const SizedBox(height: 16),
              // Filter tabs
              FilterTabsWidget(),
              const SizedBox(height: 24),
              // Dynamic section header based on selected tab
              Obx(
                () => CustomTextWidget(
                  text: controller.selectedTab.value == 'Videos'
                      ? 'All Videos'
                      : controller.selectedTab.value == 'Articles'
                      ? 'All Articles'
                      : 'All Audios',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.black,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 16),
              // Content list (Audio, Video, or Articles)
              Expanded(
                child: Obx(() {
                  if (controller.selectedTab.value == 'Videos') {
                    return ListView.builder(
                      itemCount: controller.videoFiles.length,
                      itemBuilder: (context, index) {
                        return VideoCardWidget(
                          video: controller.videoFiles[index],
                        );
                      },
                    );
                  } else if (controller.selectedTab.value == 'Articles') {
                    return ListView.builder(
                      itemCount: controller.articleFiles.length,
                      itemBuilder: (context, index) {
                        return ArticleCardWidget(
                          video: controller.articleFiles[index],
                        );
                      },
                    );
                  } else {
                    // Audios
                    return ListView.builder(
                      itemCount: controller.audioFiles.length,
                      itemBuilder: (context, index) {
                        return AudioCardWidget(
                          audio: controller.audioFiles[index],
                        );
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
