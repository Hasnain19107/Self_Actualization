import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';

class ReviewResultController extends GetxController {
  // Needs categories data
  final List<Map<String, dynamic>> needsCategories = [
    {
      'category': 'Meta Needs',
      'color': 0xFF2196F3, // Blue
      'items': [
        'Cognitive needs: to know, understand, learn',
        'Contribution needs: to make a difference',
        'Conative: to choose your unique way of life',
        'Love needs: to care and extend yourself to others',
        'Truth Needs: to know what is true, real, and authentic',
        'Aesthetic needs: to see, enjoy, and create beauty',
        'Expressive needs: to be and express your best self',
      ],
    },
    {
      'category': 'Self',
      'color': 0xFF2196F3,
      'items': [
        'Importance of your voice and opinion',
        'Honor and Dignity from colleagues',
        'Sense of Respect for Achievements',
        'Sense of Human dignity / Value as Person',
      ],
    },
    {
      'category': 'Social',
      'color': 0xFF2196F3,
      'items': [
        'Group Acceptance / Connection',
        'Bonding with Partner / Lover',
        'Bonding with Significant People',
        'Love / Affection',
        'Social connection: Friends / companions',
      ],
    },
    {
      'category': 'Safety',
      'color': 0xFF2196F3,
      'items': [
        'Sense of Control: Personal Power.efficacy',
        'Sense of Order / Structure',
        'Stability in Life',
        'Career / Job Safety',
        'Physical / Personal Safety',
      ],
    },
    {
      'category': 'Survival',
      'color': 0xFF2196F3,
      'items': [
        'Money',
        'Sex',
        'Exercise',
        'Vitality',
        'Weight Management',
        'Food',
        'Sleep',
      ],
    },
  ];

  // Scale descriptors for bottom
  final List<String> scaleDescriptors = [
    'Dysfunctional Neurotic Psychotic',
    'Extremes Too much Too Little',
    'Not getting by: Cravings Dissatisfaction',
    'Doing OK Getting By Normal Concerns',
    'Getting by well Feeling Good',
    'Doing Good Thriving',
    'Optimizing Super-Thriving',
    'Maximizing At ones are very best',
  ];

  @override
  void onInit() {
    super.onInit();
  }

  void downloadPDF() {
    ToastClass.showCustomToast('Download PDF Summary functionality', type: ToastType.simple);
  }

  void shareToCoach() {
    ToastClass.showCustomToast('Share to Coach functionality', type: ToastType.simple);
  }

  void continueAction() {
    ToastClass.showCustomToast('Continue functionality', type: ToastType.simple);
  }
}
