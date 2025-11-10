import 'package:get/get.dart';

class NotificationController extends GetxController {
  // Notification data
  final RxList<Map<String, dynamic>> notifications = <Map<String, dynamic>>[
    {
      'message': 'Lorem ipsum vitae adipiscing eget posuere ullamcorper porta.',
      'timestamp': 'Just Now',
    },
    {
      'message': 'Lorem ipsum vitae adipiscing eget posuere ullamcorper porta.',
      'timestamp': 'June19, 2025 | 12:02 AM',
    },
    {
      'message': 'Lorem ipsum vitae adipiscing eget posuere ullamcorper porta.',
      'timestamp': 'June19, 2025 | 12:02 AM',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
  }
}
