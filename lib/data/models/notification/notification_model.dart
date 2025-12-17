/// Notification Model
/// Represents a notification returned by the API
class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String type;
  final NotificationData? data;
  final bool isRead;
  final DateTime? readAt;
  final String? fcmMessageId;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.data,
    required this.isRead,
    this.readAt,
    this.fcmMessageId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      type: json['type'] as String? ?? 'general',
      data: json['data'] != null
          ? NotificationData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      isRead: json['isRead'] as bool? ?? false,
      readAt: json['readAt'] != null
          ? DateTime.tryParse(json['readAt'].toString())
          : null,
      fcmMessageId: json['fcmMessageId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'type': type,
      'data': data?.toJson(),
      'isRead': isRead,
      'readAt': readAt?.toIso8601String(),
      'fcmMessageId': fcmMessageId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    String? type,
    NotificationData? data,
    bool? isRead,
    DateTime? readAt,
    String? fcmMessageId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      fcmMessageId: fcmMessageId ?? this.fcmMessageId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Notification Data
/// Contains additional data for navigation and context
class NotificationData {
  final String? type;
  final String? goalId;
  final String? screen;

  NotificationData({
    this.type,
    this.goalId,
    this.screen,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      type: json['type'] as String?,
      goalId: json['goalId'] as String?,
      screen: json['screen'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (type != null) 'type': type,
      if (goalId != null) 'goalId': goalId,
      if (screen != null) 'screen': screen,
    };
  }
}

/// Pagination Model for notifications
class NotificationPagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  NotificationPagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory NotificationPagination.fromJson(Map<String, dynamic> json) {
    return NotificationPagination(
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      total: json['total'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
    };
  }
}

/// Notifications Response
/// Contains list of notifications with pagination
class NotificationsResponse {
  final List<NotificationModel> notifications;
  final NotificationPagination pagination;
  final int unreadCount;

  NotificationsResponse({
    required this.notifications,
    required this.pagination,
    required this.unreadCount,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      notifications: (json['notifications'] as List<dynamic>?)
              ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: json['pagination'] != null
          ? NotificationPagination.fromJson(
              json['pagination'] as Map<String, dynamic>)
          : NotificationPagination(page: 1, limit: 20, total: 0, totalPages: 0),
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
      'unreadCount': unreadCount,
    };
  }
}

/// Notification Type enum for filtering
enum NotificationType {
  goalCompleted('goal_completed'),
  goalReminder('goal_reminder'),
  assessmentReminder('assessment_reminder'),
  test('test'),
  general('general');

  final String value;
  const NotificationType(this.value);

  static NotificationType? fromString(String? value) {
    if (value == null) return null;
    return NotificationType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => NotificationType.general,
    );
  }
}
