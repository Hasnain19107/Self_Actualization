import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_actualisation/core/widgets/custom_progress_indicator.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/utils/app_sizes.dart';
import '../../../core/widgets/custom_text_widget.dart';
import '../../../core/widgets/search_bar_widget.dart';
import '../controller/learn_grow_controller.dart';
import '../../learn_grow/widgets/article_card.dart';
import '../widgets/audio_card_widget.dart';
import '../widgets/filter_tabs_widget.dart';
import '../../learn_grow/widgets/video_card_widget.dart';

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
            horizontal: appSizes.getWidthPercentage(4),
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
              // Title - show API title if available, otherwise default
              Obx(
                () => CustomTextWidget(
                  text: controller.learningTitle.value.isNotEmpty
                      ? controller.learningTitle.value
                      : 'Learn & Grow',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.black,
                  textAlign: TextAlign.left,
                  maxLines: 3,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 20),
              // Search bar
              SearchBarWidget(
                searchController: searchController,
                onChanged: (value) {
                  controller.updateSearchQuery(value);
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
                    if (controller.isLoadingVideos.value) {
                      return const Center(
                        child: CustomProgressIndicator(),
                      );
                    }
                    final filteredVideos = controller.filteredVideos;
                    if (filteredVideos.isEmpty) {
                      return Center(
                        child: CustomTextWidget(
                          text: controller.searchQuery.value.isEmpty
                              ? 'No videos available'
                              : 'No videos found',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          textColor: AppColors.grey,
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: filteredVideos.length,
                      itemBuilder: (context, index) {
                        return VideoCardWidget(
                          video: filteredVideos[index],
                        );
                      },
                    );
                  } else if (controller.selectedTab.value == 'Articles') {
                    if (controller.isLoadingArticles.value) {
                      return const Center(
                        child: CustomProgressIndicator(),
                      );
                    }
                    final filteredArticles = controller.filteredArticles;
                    if (filteredArticles.isEmpty) {
                      return Center(
                        child: CustomTextWidget(
                          text: controller.searchQuery.value.isEmpty
                              ? 'No articles available'
                              : 'No articles found',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          textColor: AppColors.grey,
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: filteredArticles.length,
                      itemBuilder: (context, index) {
                        return ArticleCardWidget(
                          article: filteredArticles[index],
                        );
                      },
                    );
                  } else {
                    // Audios
                    if (controller.isLoadingAudios.value) {
                      return const Center(
                        child: CustomProgressIndicator(),
                      );
                    }
                    final filteredAudios = controller.filteredAudios;
                    if (filteredAudios.isEmpty) {
                      return Center(
                        child: CustomTextWidget(
                          text: controller.searchQuery.value.isEmpty
                              ? 'No audios available'
                              : 'No audios found',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          textColor: AppColors.grey,
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: filteredAudios.length,
                      itemBuilder: (context, index) {
                        return AudioCardWidget(
                          audio: filteredAudios[index],
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
