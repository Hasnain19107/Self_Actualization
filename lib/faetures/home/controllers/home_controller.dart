import 'package:get/get.dart';

class HomeController extends GetxController {
  // Fuel types data
  final List<Map<String, String>> fuelTypes = [
    {
      'name': 'Diesel',
      'category': 'Diesel',
      'price': '\$2.95/gal',
    },
    {
      'name': 'Regular',
      'category': 'Gasoline',
      'price': '\$3.45/gal',
    },
    {
      'name': 'MidGrade',
      'category': 'Gasoline',
      'price': '\$4.25/gal',
    },
    {
      'name': 'Premium',
      'category': 'Gasoline',
      'price': '\$4.99/gal',
    },
  ];

  // Reactive variables
  final RxInt selectedFuelIndex = (-1).obs;
  final RxString amount = ''.obs;
  final RxDouble gallons = 0.0.obs;
  final RxDouble gasCredits = 20.25.obs;

  // Selected fuel price per gallon
  double get selectedFuelPrice {
    if (selectedFuelIndex.value >= 0 && selectedFuelIndex.value < fuelTypes.length) {
      final priceStr = fuelTypes[selectedFuelIndex.value]['price'] ?? '0';
      final price = double.tryParse(priceStr.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
      return price;
    }
    return 0.0;
  }

  void selectFuel(int index) {
    selectedFuelIndex.value = index;
    calculateGallons();
  }

  void addNumber(String number) {
    if (amount.value.isEmpty || amount.value == '0') {
      amount.value = number;
    } else {
      amount.value += number;
    }
    calculateGallons();
  }

  void addDecimal() {
    if (amount.value.isEmpty) {
      amount.value = '0.';
    } else if (!amount.value.contains('.')) {
      amount.value += '.';
    }
  }

  void backspace() {
    if (amount.value.length > 1) {
      amount.value = amount.value.substring(0, amount.value.length - 1);
    } else {
      amount.value = '';
    }
    calculateGallons();
  }

  void clear() {
    amount.value = '';
    gallons.value = 0.0;
  }

  void calculateGallons() {
    final amountValue = double.tryParse(amount.value) ?? 0.0;
    if (selectedFuelPrice > 0 && amountValue > 0) {
      gallons.value = amountValue / selectedFuelPrice;
    } else {
      gallons.value = 0.0;
    }
  }

  String get formattedAmount {
    if (amount.value.isEmpty) return '\$0.00';
    final amountValue = double.tryParse(amount.value) ?? 0.0;
    return '\$${amountValue.toStringAsFixed(2)}';
  }
  
  String get formattedGallons => gallons.value.toStringAsFixed(1);

  void submit() {
    if (selectedFuelIndex.value < 0) {
      Get.snackbar('Error', 'Please select a fuel type');
      return;
    }
    final amountValue = double.tryParse(amount.value);
    if (amountValue == null || amountValue <= 0) {
      Get.snackbar('Error', 'Please enter a valid amount');
      return;
    }
    // Handle submit logic here
    Get.snackbar('Success', 'Transaction submitted');
  }
}
