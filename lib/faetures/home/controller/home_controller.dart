import 'package:get/get.dart';
import '../../learn_grow/view/learn_grow_screen.dart';
import '../../../core/const/app_exports.dart';
import '../../../core/models/need_data.dart';

class HomeController extends GetxController {
  // User info
  final RxString userName = '@DuozhuaMiao'.obs;
  final RxString greeting = 'Good morning'.obs;

  // List of needs
  final RxList<NeedData> needs = <NeedData>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeNeeds();
  }

  void _initializeNeeds() {
    needs.value = [
      NeedData(
        id: 'self_actualization_1',
        title: 'Self Actualization',
        vValue: 3.0.obs,
        qValue: 7.0.obs,
        isGreen: true,
      ),
      NeedData(
        id: 'self_needs',
        title: 'Self Needs',
        vValue: 2.0.obs,
        qValue: 8.0.obs,
        isGreen: false,
      ),
      NeedData(
        id: 'social_needs',
        title: 'Social Needs',
        vValue: 3.0.obs,
        qValue: 7.0.obs,
        isGreen: true,
      ),
      NeedData(
        id: 'safety_needs',
        title: 'Safety Needs',
        vValue: 3.0.obs,
        qValue: 7.0.obs,
        isGreen: false,
      ),
      NeedData(
        id: 'self_actualization_2',
        title: 'Self Actualization',
        vValue: 3.0.obs,
        qValue: 7.0.obs,
        isGreen: true,
      ),
    ];
  }

  void updateVValue(String needId, double value) {
    final need = needs.firstWhereOrNull((n) => n.id == needId);
    if (need != null) {
      need.vValue.value = value.clamp(0.0, 10.0);
    }
  }

  void updateQValue(String needId, double value) {
    final need = needs.firstWhereOrNull((n) => n.id == needId);
    if (need != null) {
      need.qValue.value = value.clamp(0.0, 10.0);
    }
  }

  // Action cards
  final List<Map<String, dynamic>> actionCards = [
    {'title': 'Learn & Grow', 'emoji': '🧘'},
    {'title': 'Journal', 'emoji': '✏️'},
    {'title': 'Self Assessment', 'emoji': '💬'},
  ];

  void onActionCardTap(String title) {
    // Handle action card tap
    if (title == 'Learn & Grow') {
      Get.to(() => LearnGrowScreen());
    } else {
      ToastClass.showCustomToast('Tapped on $title', type: ToastType.simple);
    }
  }
}
