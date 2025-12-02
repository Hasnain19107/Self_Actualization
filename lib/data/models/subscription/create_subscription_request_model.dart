/// Create Subscription Request Model
/// Request body for creating a subscription
class CreateSubscriptionRequestModel {
  final String subscriptionType; // "Free", "Premium", "Coach"
  final String stripePaymentIntentId;
  final String stripeCustomerId;
  final String paymentStatus; // "succeeded", "pending", "failed"

  CreateSubscriptionRequestModel({
    required this.subscriptionType,
    required this.stripePaymentIntentId,
    required this.stripeCustomerId,
    required this.paymentStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'subscriptionType': subscriptionType,
      'stripePaymentIntentId': stripePaymentIntentId,
      'stripeCustomerId': stripeCustomerId,
      'paymentStatus': paymentStatus,
    };
  }
}

