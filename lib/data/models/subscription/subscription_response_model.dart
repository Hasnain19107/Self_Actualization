import 'subscription_model.dart';

/// Subscription Response Model
/// Response from subscription API endpoints
class SubscriptionResponseModel {
  final SubscriptionModel? subscription;
  final List<String> availableCategories;
  final String? subscriptionType;
  final int? pricing;

  SubscriptionResponseModel({
    this.subscription,
    required this.availableCategories,
    this.subscriptionType,
    this.pricing,
  });

  factory SubscriptionResponseModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionResponseModel(
      subscription: json['subscription'] != null
          ? SubscriptionModel.fromJson(
              json['subscription'] as Map<String, dynamic>)
          : null,
      availableCategories: (json['availableCategories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      subscriptionType: json['subscriptionType'] as String?,
      pricing: json['pricing'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscription': subscription?.toJson(),
      'availableCategories': availableCategories,
      'subscriptionType': subscriptionType,
      'pricing': pricing,
    };
  }
}

