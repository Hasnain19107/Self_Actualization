import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/const/app_exports.dart';
import '../../../data/models/notification/notification_model.dart';
import '../controller/notification_controller.dart';

class NotificationCardWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const NotificationCardWidget({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.red,
        child: const Icon(
          Icons.delete,
          color: AppColors.white,
          size: 28,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: notification.isRead
                ? AppColors.white
                : const Color(0xFFE8F4FD), // Light blue for unread
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification icon based on type
              _buildNotificationIcon(),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with unread indicator
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextWidget(
                            text: notification.title,
                            fontSize: 15,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w600,
                            textColor: const Color(0xFF1A1A2E),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Body
                    CustomTextWidget(
                      text: notification.body,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      textColor: const Color(0xFF666666),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Time and type tag
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        CustomTextWidget(
                          text: _formatTime(notification.createdAt),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          textColor: Colors.grey.shade500,
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(width: 12),
                        _buildTypeChip(),
                      ],
                    ),
                  ],
                ),
              ),
              // Action buttons
              PopupMenuButton<String>(
                color: AppColors.white,
                icon: Icon(
                  Icons.more_vert,
                  size: 20,
                  color: Colors.grey.shade600,
                ),
                padding: EdgeInsets.zero,
                onSelected: (value) => _handleAction(value, context),
                itemBuilder: (context) => [
                  if (!notification.isRead)
                    const PopupMenuItem(
                      value: 'mark_read',
                      child: Row(
                        children: [
                          Icon(Icons.done, size: 18),
                          SizedBox(width: 8),
                          Text('Mark as read'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18, color: AppColors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: AppColors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    IconData icon;
    Color backgroundColor;
    Color iconColor;

    switch (notification.type) {
      case 'goal_completed':
        icon = Icons.emoji_events;
        backgroundColor = const Color(0xFFE8F5E9);
        iconColor = const Color(0xFF4CAF50);
        break;
      case 'goal_reminder':
        icon = Icons.flag;
        backgroundColor = const Color(0xFFFFF3E0);
        iconColor = const Color(0xFFFF9800);
        break;
      case 'assessment_reminder':
        icon = Icons.assignment;
        backgroundColor = const Color(0xFFE3F2FD);
        iconColor = const Color(0xFF2196F3);
        break;
      case 'test':
        icon = Icons.bug_report;
        backgroundColor = const Color(0xFFFCE4EC);
        iconColor = const Color(0xFFE91E63);
        break;
      case 'general':
      default:
        icon = Icons.notifications;
        backgroundColor = const Color(0xFFF3E5F5);
        iconColor = const Color(0xFF9C27B0);
        break;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: 22,
        color: iconColor,
      ),
    );
  }

  Widget _buildTypeChip() {
    final controller = Get.find<NotificationController>();
    final displayText = controller.getTypeDisplayText(notification.type);

    Color chipColor;
    switch (notification.type) {
      case 'goal_completed':
        chipColor = const Color(0xFF4CAF50);
        break;
      case 'goal_reminder':
        chipColor = const Color(0xFFFF9800);
        break;
      case 'assessment_reminder':
        chipColor = const Color(0xFF2196F3);
        break;
      case 'test':
        chipColor = const Color(0xFFE91E63);
        break;
      case 'general':
      default:
        chipColor = const Color(0xFF9C27B0);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: CustomTextWidget(
        text: displayText,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        textColor: chipColor,
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

  void _handleAction(String action, BuildContext context) {
    final controller = Get.find<NotificationController>();

    switch (action) {
      case 'mark_read':
        controller.markAsRead(notification.id);
        break;
      case 'delete':
        controller.deleteNotification(notification.id);
        break;
    }
  }
}
