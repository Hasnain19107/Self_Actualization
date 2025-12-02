/// Subscription Model
/// Represents a user's subscription
class SubscriptionModel {
  final String id;
  final String subscriptionType; // "Free", "Premium", "Coach"
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? expiresAt;

  SubscriptionModel({
    required this.id,
    required this.subscriptionType,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.expiresAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      subscriptionType: json['subscriptionType'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subscriptionType': subscriptionType,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }
}

