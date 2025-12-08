import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/const/app_exports.dart';
import '../../../data/models/user/user_model.dart';

class ProfileAvatarSectionWidget extends StatelessWidget {
  final UserModel user;

  const ProfileAvatarSectionWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.inputBorderGrey,
                width: 3,
              ),
            ),
            child: ClipOval(
              child: _buildAvatarImage(),
            ),
          ),
          const Gap(16),
          CustomTextWidget(
            text: user.name,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            textColor: AppColors.black,
            textAlign: TextAlign.center,
          ),
          if (user.email.isNotEmpty) ...[
            const Gap(8),
            CustomTextWidget(
              text: user.email,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: AppColors.mediumGray,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Build avatar image based on the avatar type (URL or asset path)
  Widget _buildAvatarImage() {
    final avatar = user.avatar;
    
    // No avatar set - show default icon
    if (avatar == null || avatar.isEmpty) {
      return _buildDefaultAvatar();
    }
    
    // Check if it's a URL (uploaded custom avatar)
    if (avatar.startsWith('http://') || avatar.startsWith('https://')) {
      return Image.network(
        avatar,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: AppColors.lightGray,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.blue,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultAvatar();
        },
      );
    }
    
    // Asset path (preset avatar)
    return Image.asset(
      avatar,
      fit: BoxFit.cover,
      width: 120,
      height: 120,
      errorBuilder: (context, error, stackTrace) {
        return _buildDefaultAvatar();
      },
    );
  }

  /// Build default avatar with person icon
  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.lightGray,
      child: const Icon(
        Icons.person,
        size: 60,
        color: AppColors.mediumGray,
      ),
    );
  }
}