import 'package:get/get.dart';

/// Shared model representing a single need slider entry.
class NeedData {
  final String title;
  final RxDouble vValue;
  final RxDouble qValue;
  final bool isGreen;
  final String id;

  NeedData({
    required this.title,
    required this.vValue,
    required this.qValue,
    required this.isGreen,
    required this.id,
  });
}

