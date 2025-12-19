import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import '../../../core/const/app_exports.dart';
import '../../../data/models/subscription/create_subscription_request_model.dart';
import '../../../data/models/subscription/subscription_response_model.dart';
import '../../../data/repository/subscription_repository.dart';

class SubscriptionController extends GetxController {
  final SubscriptionRepository _subscriptionRepository = SubscriptionRepository();
  
  // Store selected plan
  final RxString selectedPlanId = ''.obs;
  
  // Current subscription from API
  final Rx<SubscriptionResponseModel?> currentSubscription = Rx<SubscriptionResponseModel?>(null);
  final RxBool isLoadingCurrentSubscription = false.obs;
  
  // Available categories for selected plan
  final RxList<String> availableCategories = <String>[].obs;
  final RxBool isLoadingAvailableCategories = false.obs;
  final RxString errorMessage = ''.obs;
  
  // Subscription plans data
  final List<Map<String, dynamic>> subscriptionPlans = [
    {'planName': 'Free', 'price': 'A\$0', 'planId': 'free', 'subscriptionType': 'Free'},
    {'planName': 'Premium', 'price': 'A\$19', 'planId': 'premium', 'subscriptionType': 'Premium'},
    {'planName': 'Coach', 'price': 'A\$39', 'planId': 'coach', 'subscriptionType': 'Coach'},
  ];
  
  // Loading states
  final RxBool isProcessingPayment = false.obs;
  final RxBool isCreatingSubscription = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentSubscription();
  }

  /// Fetch current subscription from API (includes availableCategories in response)
  Future<void> fetchCurrentSubscription() async {
    try {
      isLoadingCurrentSubscription.value = true;
      isLoadingAvailableCategories.value = true;
      errorMessage.value = '';
      
      DebugUtils.logInfo(
        'Fetching current subscription...',
        tag: 'SubscriptionController.fetchCurrentSubscription',
      );
      
      final response = await _subscriptionRepository.getCurrentSubscription();
      
      isLoadingCurrentSubscription.value = false;
      isLoadingAvailableCategories.value = false;
      
      DebugUtils.logInfo(
        'API Response - success: ${response.success}, data: ${response.data}, message: ${response.message}',
        tag: 'SubscriptionController.fetchCurrentSubscription',
      );
      
      if (response.success && response.data != null) {
        currentSubscription.value = response.data;
        
        DebugUtils.logInfo(
          'Current subscription type: ${response.data!.subscriptionType}',
          tag: 'SubscriptionController.fetchCurrentSubscription',
        );
        
        // Extract available categories from the response
        availableCategories.assignAll(response.data!.availableCategories);
      } else {
        // No subscription found or error - set to null
        currentSubscription.value = null;
        availableCategories.clear();
        errorMessage.value = response.message.isNotEmpty
            ? response.message
            : 'No active subscription found';
      }
    } catch (e) {
      isLoadingCurrentSubscription.value = false;
      isLoadingAvailableCategories.value = false;
      DebugUtils.logError(
        'Error fetching current subscription',
        tag: 'SubscriptionController.fetchCurrentSubscription',
        error: e,
      );
      currentSubscription.value = null;
      availableCategories.clear();
      errorMessage.value = 'Failed to load subscription. Please try again.';
    }
  }

  /// Fetch available categories by subscription type
  Future<void> fetchAvailableCategoriesByType(String subscriptionType) async {
    try {
      isLoadingAvailableCategories.value = true;
      errorMessage.value = '';
      
      final response = await _subscriptionRepository.getAvailableCategories(subscriptionType);
      
      isLoadingAvailableCategories.value = false;
      
      if (response.success && response.data != null) {
        availableCategories.assignAll(response.data!.availableCategories);
      } else {
        errorMessage.value = response.message.isNotEmpty
            ? response.message
            : 'Failed to load available categories';
        availableCategories.clear();
      }
    } catch (e) {
      isLoadingAvailableCategories.value = false;
      errorMessage.value = 'An error occurred. Please try again.';
      availableCategories.clear();
      DebugUtils.logError(
        'Error fetching available categories',
        tag: 'SubscriptionController.fetchAvailableCategoriesByType',
        error: e,
      );
    }
  }

  /// Get current active plan ID from subscription API
  String? get currentActivePlanId {
    final subscription = currentSubscription.value;
    if (subscription == null) return null;
    
    final subscriptionType = subscription.subscriptionType;
    if (subscriptionType == null || subscriptionType.isEmpty) {
      return null;
    }
    
    // Map subscription type to planId
    final typeLower = subscriptionType.toLowerCase();
    if (typeLower == 'free') {
      return 'free';
    } else if (typeLower == 'premium') {
      return 'premium';
    } else if (typeLower == 'coach') {
      return 'coach';
    }
    
    return null;
  }

  /// Get current active plan data
  Map<String, dynamic>? get currentActivePlan {
    final planId = currentActivePlanId;
    if (planId == null) return null;
    
    return subscriptionPlans.firstWhereOrNull(
      (plan) => plan['planId'] == planId,
    );
  }

  /// Check if a plan is the current active plan
  bool isCurrentPlan(String planId) {
    return currentActivePlanId == planId;
  }

  /// Fetch available categories for a plan ID (used in select plan screen)
  Future<void> fetchAvailableCategories(String planId) async {
    try {
      isLoadingAvailableCategories.value = true;
      errorMessage.value = '';
      
      // Map planId to subscriptionType
      final plan = subscriptionPlans.firstWhereOrNull(
        (p) => p['planId'] == planId,
      );
      
      if (plan == null) {
        availableCategories.clear();
        isLoadingAvailableCategories.value = false;
        return;
      }
      
      final subscriptionType = plan['subscriptionType'] as String;
      await fetchAvailableCategoriesByType(subscriptionType);
    } catch (e) {
      isLoadingAvailableCategories.value = false;
      errorMessage.value = 'An error occurred. Please try again.';
      availableCategories.clear();
      DebugUtils.logError(
        'Error fetching available categories',
        tag: 'SubscriptionController.fetchAvailableCategories',
        error: e,
      );
    }
  }

  /// Refresh current subscription data
  Future<void> refreshCurrentSubscription() async {
    await fetchCurrentSubscription();
  }

  // Initialize plan ID from arguments
  void initializePlan(Map<String, dynamic>? planData) {
    if (planData != null) {
      selectedPlanId.value = planData['planId'] as String? ?? '';
    }
  }

  // Select plan
  void selectPlan(Map<String, dynamic> plan) {
    final planId = plan['planId'] as String? ?? '';

    if (selectedPlanId.value != planId) {
      selectedPlanId.value = planId;
    }
  }

  // Getter for currently selected plan data
  Map<String, dynamic>? get currentPlan => subscriptionPlans.firstWhereOrNull(
        (plan) => plan['planId'] == selectedPlanId.value,
      );

  // Getter for selected plan name
  String get selectedPlanName {
    final plan = currentPlan;
    return plan != null ? plan['planName'] as String? ?? '' : '';
  }

  // Getter for selected plan price
  String get selectedPlanPrice {
    final plan = currentPlan;
    return plan != null ? plan['price'] as String? ?? '' : '';
  }
  
  // Check if plan is selected
  bool get hasSelectedPlan => selectedPlanId.value.isNotEmpty;
  
  // Handle continue from select plan screen
  Future<void> handlePlanContinue() async {
    if (!hasSelectedPlan) {
      ToastClass.showCustomToast(
        'Please select a plan to continue',
        type: ToastType.error,
      );
      return;
    }
    
    final planData = currentPlan;
    if (planData == null) {
      ToastClass.showCustomToast(
        'Something went wrong. Please select a plan again.',
        type: ToastType.error,
      );
      return;
    }

    // For Free plan, skip payment and go directly to category selection
    if (selectedPlanId.value == 'free') {
      await _processFreePlan(planData);
      return;
    }

    // For paid plans, process payment (hardcoded for now)
    await _processPayment(planData);
  }

  // Process free plan - no payment needed
  Future<void> _processFreePlan(Map<String, dynamic> planData) async {
    try {
      isCreatingSubscription.value = true;
      
      // Create subscription for free plan
      final subscriptionRequest = CreateSubscriptionRequestModel(
        subscriptionType: planData['subscriptionType'] as String,
        stripePaymentIntentId: 'free_plan_no_payment',
        stripeCustomerId: 'free_plan_no_customer',
        paymentStatus: 'succeeded',
      );

      final response = await _subscriptionRepository.createSubscription(subscriptionRequest);

      if (response.success && response.data != null) {
        // Refresh current subscription after creating new one
        await fetchCurrentSubscription();
        
        Get.toNamed(
          AppRoutes.categoryLevelScreen,
          arguments: planData,
        );
      } else {
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to create subscription. Please try again.',
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastClass.showCustomToast(
        'Failed to process free plan: ${e.toString()}',
        type: ToastType.error,
      );
    } finally {
      isCreatingSubscription.value = false;
    }
  }

  // PayPal Credentials - loaded from ..env file
  // For sandbox testing, use sandbox credentials
  // For production, use live credentials and set PAYPAL_SANDBOX_MODE=false
  String get _paypalClientId => dotenv.env['PAYPAL_CLIENT_ID'] ?? '';
  String get _paypalSecretKey => dotenv.env['PAYPAL_SECRET_KEY'] ?? '';
  bool get _paypalSandboxMode => dotenv.env['PAYPAL_SANDBOX_MODE']?.toLowerCase() == 'true';

  // Process payment using PayPal
  Future<void> _processPayment(Map<String, dynamic> planData) async {
    final priceString = planData['price'] as String? ?? '\$0';
    // Extract numeric value from price string (e.g., "$19" -> "19")
    final priceValue = priceString.replaceAll(RegExp(r'[^\d.]'), '');
    final planName = planData['planName'] as String? ?? 'Subscription';

    // Navigate to PayPal checkout
    Get.to(() => PaypalCheckoutView(
      sandboxMode: _paypalSandboxMode,
      clientId: _paypalClientId,
      secretKey: _paypalSecretKey,
      transactions: [
        {
          "amount": {
            "total": priceValue,
            "currency": "AUD",
            "details": {
              "subtotal": priceValue,
              "shipping": '0',
              "shipping_discount": 0,
            }
          },
          "description": "Self Actualization - $planName Plan Subscription",
          "item_list": {
            "items": [
              {
                "name": "$planName Plan",
                "quantity": 1,
                "price": priceValue,
                "currency": "AUD"
              }
            ],
          }
        }
      ],
      note: "Thank you for subscribing to Self Actualization!",
      onSuccess: (Map params) async {
        DebugUtils.logInfo(
          'PayPal Payment Success: $params',
          tag: 'SubscriptionController._processPayment',
        );
        
        // Extract payment details from PayPal response
        final paymentId = params['paymentId'] as String? ?? 
            'paypal_${DateTime.now().millisecondsSinceEpoch}';
        final payerId = params['payerID'] as String? ?? 
            'payer_${DateTime.now().millisecondsSinceEpoch}';
        
        // Go back from PayPal view
        Get.back();
        
        // Create subscription after successful payment
        await _createSubscriptionAfterPayment(
          planData: planData,
          paymentId: paymentId,
          payerId: payerId,
        );
      },
      onError: (error) {
        DebugUtils.logError(
          'PayPal Payment Error',
          tag: 'SubscriptionController._processPayment',
          error: error,
        );
        Get.back();
        ToastClass.showCustomToast(
          'Payment failed. Please try again.',
          type: ToastType.error,
        );
      },
      onCancel: () {
        DebugUtils.logInfo(
          'PayPal Payment Cancelled',
          tag: 'SubscriptionController._processPayment',
        );
        Get.back();
        ToastClass.showCustomToast(
          'Payment cancelled',
          type: ToastType.warning,
        );
      },
    ));
  }

  // Create subscription after successful PayPal payment
  Future<void> _createSubscriptionAfterPayment({
    required Map<String, dynamic> planData,
    required String paymentId,
    required String payerId,
  }) async {
    try {
      isCreatingSubscription.value = true;

      // Create subscription with PayPal payment details
      final subscriptionRequest = CreateSubscriptionRequestModel(
        subscriptionType: planData['subscriptionType'] as String,
        stripePaymentIntentId: paymentId, // Using PayPal payment ID
        stripeCustomerId: payerId, // Using PayPal payer ID
        paymentStatus: 'succeeded',
      );

      final response = await _subscriptionRepository.createSubscription(subscriptionRequest);

      if (response.success && response.data != null) {
        ToastClass.showCustomToast(
          'Subscription activated successfully!',
          type: ToastType.success,
        );
        
        // Refresh current subscription after creating new one
        await fetchCurrentSubscription();
        
        Get.toNamed(
          AppRoutes.categoryLevelScreen,
          arguments: planData,
        );
      } else {
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to activate subscription. Please contact support.',
          type: ToastType.error,
        );
      }
    } catch (e) {
      DebugUtils.logError(
        'Error creating subscription after payment',
        tag: 'SubscriptionController._createSubscriptionAfterPayment',
        error: e,
      );
      ToastClass.showCustomToast(
        'Failed to activate subscription: ${e.toString()}',
        type: ToastType.error,
      );
    } finally {
      isCreatingSubscription.value = false;
    }
  }

  final List<String> metaNeedsOptions = [
    'Cognitive needs: to know, understand, learn',
    'Contribution needs: to make a difference',
    'Conative: to choose your unique way of life',
    'Love needs: to care and extend yourself to others',
    'Truth Needs: to know what is true, real, and authentic',
    'Aesthetic needs: to see, enjoy, and create beauty',
  ];

  // Levels (Self, Social, Safety, Survival)
  final List<Map<String, String>> levels = [
    {'name': 'Self', 'emoji': '✏️'},
    {'name': 'Social', 'emoji': '💬'},
    {'name': 'Safety', 'emoji': '💪'},
    {'name': 'Survival', 'emoji': '😊'},
  ];

  // Reactive variables for selections
  final RxSet<String> selectedMetaNeeds = <String>{}.obs;
  final RxSet<String> selectedLevels = <String>{}.obs;

  // Check if meta need is locked based on plan
  bool isMetaNeedLocked(String option) {
    final planId = selectedPlanId.value;
    final index = metaNeedsOptions.indexOf(option);
    
    if (planId == 'free') {
      // Free plan: only first 2 unlocked
      return index >= 2;
    } else if (planId == 'premium') {
      // Premium plan: first 5 unlocked
      return index >= 5;
    } else if (planId == 'coach') {
      // Coach plan: all unlocked
      return false;
    }
    // Default: all locked if no plan selected
    return true;
  }

  // Toggle Meta Needs selection (multiple selection allowed)
  void toggleMetaNeed(String option) {
    // Don't allow selection if locked
    if (isMetaNeedLocked(option)) {
      ToastClass.showCustomToast(
        'This feature is locked. Please upgrade your plan.',
        type: ToastType.error,
      );
      return;
    }

    if (selectedMetaNeeds.contains(option)) {
      selectedMetaNeeds.remove(option);
    } else {
      selectedMetaNeeds.add(option);
    }
  }

  // Check if Meta Need is selected
  bool isMetaNeedSelected(String option) {
    return selectedMetaNeeds.contains(option);
  }

  // Check if level is locked based on plan
  bool isLevelLocked(String levelName) {
    final planId = selectedPlanId.value;
    final index = levels.indexWhere((level) => level['name'] == levelName);
    
    if (index == -1) return true; // Level not found
    
    if (planId == 'free') {
      // Free plan: only first 2 levels unlocked
      return index >= 2;
    } else if (planId == 'premium' || planId == 'coach') {
      // Premium and Coach plans: all levels unlocked
      return false;
    }
    // Default: all locked if no plan selected
    return true;
  }

  // Toggle level selection (multiple selection allowed)
  void toggleLevel(String levelName) {
    // Don't allow selection if locked
    if (isLevelLocked(levelName)) {
      ToastClass.showCustomToast(
        'This level is locked. Please upgrade your plan.',
        type: ToastType.error,
      );
      return;
    }

    if (selectedLevels.contains(levelName)) {
      selectedLevels.remove(levelName);
    } else {
      selectedLevels.add(levelName);
    }
  }

  // Check if level is selected
  bool isLevelSelected(String levelName) {
    return selectedLevels.contains(levelName);
  }

  // Submit selection
  void submitSelection() {
    if (selectedMetaNeeds.isEmpty || selectedLevels.isEmpty) {
      ToastClass.showCustomToast('Please select meta needs and at least one level', type: ToastType.error);
      return;
    }
    // Handle submit logic here
    ToastClass.showCustomToast('Selection saved', type: ToastType.success);
    // Navigate to next screen if needed
    // Get.toNamed(AppRoutes.NEXTSCREEN);
  }
}
