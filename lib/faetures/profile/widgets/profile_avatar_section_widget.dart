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
              child: user.avatar != null && user.avatar!.isNotEmpty
                  ? Image.asset(
                      user.avatar!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.lightGray,
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: AppColors.mediumGray,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: AppColors.lightGray,
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: AppColors.mediumGray,
                      ),
                    ),
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
}

