import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/Const/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String)? onChanged;
  final VoidCallback? onMicTap;

  const SearchBarWidget({
    super.key,
    required this.searchController,
    this.onChanged,
    this.onMicTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 285,
          height: 44,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.inputBorderGrey, width: 1),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 20),
              const Gap(12),
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: onChanged,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: AppColors.placeholderGrey,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
        Gap(5),
        GestureDetector(
          onTap: onMicTap,
          child: Container(
            width: 40,
            height: 44,
            padding: const EdgeInsets.only(
              top: 5,
              right: 10,
              bottom: 5,
              left: 10,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.inputBorderGrey, width: 1),
            ),
            child: const Center(child: Icon(Icons.mic, size: 15)),
          ),
        ),
      ],
    );
  }
}
