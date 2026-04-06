import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/const/app_exports.dart';
import '../../../core/controllers/user_controller.dart';
import '../../../data/models/user/user_model.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/services/fcm_service.dart';

/// Must match server `DELETE_ACCOUNT_CONFIRMATION_PHRASE` in authController.js
const String kDeleteAccountConfirmationPhrase = 'DELETE MY ACCOUNT';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key, required this.user});

  final UserModel user;

  static Future<void> show(UserModel user) {
    return Get.dialog<void>(
      DeleteAccountDialog(user: user),
      barrierDismissible: false,
    );
  }

  bool get usePasswordField {
    if (user.hasPassword == false) return false;
    if (user.hasPassword == true) return true;
    return user.isOAuthUser != true;
  }

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDelete() async {
    final repo = UserRepository();
    final usePwd = widget.usePasswordField;
    final raw = _controller.text.trim();

    if (usePwd) {
      if (raw.isEmpty) {
        ToastClass.showCustomToast(
          'Enter your password to confirm.',
          type: ToastType.error,
        );
        return;
      }
    } else {
      if (raw != kDeleteAccountConfirmationPhrase) {
        ToastClass.showCustomToast(
          'Type "$kDeleteAccountConfirmationPhrase" exactly to confirm.',
          type: ToastType.error,
        );
        return;
      }
    }

    setState(() => _submitting = true);

    final response = await repo.deleteAccount(
      password: usePwd ? raw : null,
      confirmationPhrase: usePwd ? null : raw,
    );

    if (!mounted) return;
    setState(() => _submitting = false);

    if (response.success) {
      Get.back();

      try {
        final fcm = FcmService();
        await fcm.removeToken();
      } catch (_) {}

      try {
        await FirebaseAuth.instance.signOut();
      } catch (_) {}

      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {}

      if (Get.isRegistered<UserController>()) {
        Get.find<UserController>().clearSession();
      }

      Get.offAllNamed(AppRoutes.loginScreen);

      ToastClass.showCustomToast(
        response.message.isNotEmpty
            ? response.message
            : 'Your account has been deleted.',
        type: ToastType.success,
      );
    } else {
      ToastClass.showCustomToast(
        response.message.isNotEmpty
            ? response.message
            : 'Could not delete account. Try again.',
        type: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final usePwd = widget.usePasswordField;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CustomTextWidget(
              text: 'Delete account',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              textColor: AppColors.black,
              textAlign: TextAlign.center,
            ),
            const Gap(12),
            CustomTextWidget(
              text: usePwd
                  ? 'This permanently deletes your account, assessments, goals, reflections, and subscription records. Enter your password to confirm.'
                  : 'This permanently deletes your account and all associated data. Type the phrase below exactly to confirm.',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: AppColors.mediumGray,
              textAlign: TextAlign.left,
            ),
            const Gap(16),
            if (usePwd)
              TextField(
                controller: _controller,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              )
            else ...[
              CustomTextWidget(
                text: 'Type: $kDeleteAccountConfirmationPhrase',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                textColor: AppColors.black,
                textAlign: TextAlign.left,
              ),
              const Gap(8),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: kDeleteAccountConfirmationPhrase,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                autocorrect: false,
                enableSuggestions: false,
              ),
            ],
            const Gap(24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _submitting ? null : () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.darkwhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.inputBorderGrey,
                          width: 1,
                        ),
                      ),
                      child: const CustomTextWidget(
                        text: 'Cancel',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: AppColors.black,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: GestureDetector(
                    onTap: _submitting ? null : _onDelete,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: _submitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const CustomTextWidget(
                                text: 'Delete',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                textColor: AppColors.white,
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
