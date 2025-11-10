import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../core/const/app_exports.dart';
import 'daily_reflection_controller.dart';

class AddReflectionController extends GetxController {
  final TextEditingController reflectionController = TextEditingController();
  final RxString selectedMood = ''.obs;
  final RxInt characterCount = 0.obs;
  final int maxCharacters = 300;

  final stt.SpeechToText _speech = stt.SpeechToText();
  final RxBool isListening = false.obs;
  final RxBool isAvailable = false.obs;

  // Mood emojis for selection (6 moods, no day labels)
  final List<Map<String, dynamic>> moodOptions = [
    {
      'imagePath': AppImages.sleepEmoji,
      'bgColor': const Color(0xFFFFB74D),
    }, // Orange - sleeping
    {
      'imagePath': AppImages.teethEmoji,
      'bgColor': const Color(0xFFFFEE58),
    }, // Yellow - grimacing
    {
      'imagePath': AppImages.silentEmoji,
      'bgColor': const Color(0xFF81D4FA),
    }, // Light Blue - sad
    {
      'imagePath': AppImages.wonderEmoji,
      'bgColor': const Color(0xFFF8BBD0),
    }, // Light Pink - blushing/sweating
    {
      'imagePath': AppImages.hardEmoji,
      'bgColor': const Color(0xFF42A5F5),
    }, // Dark Blue - neutral
    {
      'imagePath': AppImages.happyEmoji,
      'bgColor': const Color(0xFFFFEE58),
    }, // Yellow - laughing
  ];

  @override
  void onInit() {
    super.onInit();
    reflectionController.addListener(_updateCharacterCount);
    _initializeSpeech();
  }

  void _initializeSpeech() async {
    isAvailable.value = await _speech.initialize(
      onError: (error) {
        Get.snackbar('Error', 'Speech recognition error: ${error.errorMsg}');
        isListening.value = false;
      },
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          isListening.value = false;
        }
      },
    );
  }

  void _updateCharacterCount() {
    characterCount.value = reflectionController.text.length;
  }

  void selectMood(int index) {
    final imagePath = moodOptions[index]['imagePath'] as String;
    if (selectedMood.value == imagePath) {
      selectedMood.value = ''; // Deselect if same mood is tapped
    } else {
      selectedMood.value = imagePath;
    }
  }

  void onMicTap() {
    if (!isAvailable.value) {
      Get.snackbar('Error', 'Speech recognition is not available');
      return;
    }

    if (isListening.value) {
      // Stop listening
      _speech.stop();
      isListening.value = false;
    } else {
      // Start listening
      _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            // Final result - append to existing text
            final currentText = reflectionController.text;
            final newWords = result.recognizedWords;
            final newText = currentText.isEmpty
                ? newWords
                : '$currentText $newWords';

            // Ensure we don't exceed max characters
            if (newText.length <= maxCharacters) {
              reflectionController.text = newText;
            } else {
              reflectionController.text = newText.substring(0, maxCharacters);
              Get.snackbar('Info', 'Character limit reached');
              _speech.stop();
              isListening.value = false;
            }
          } else {
            // Interim results - speech recognition is processing
            // Final results will be used for text input
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        localeId: 'en_US',
        partialResults: true, // Show interim results
      );
      isListening.value = true;
    }
  }

  void saveReflection() {
    if (reflectionController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please write your reflection');
      return;
    }
    if (selectedMood.value.isEmpty) {
      Get.snackbar('Error', 'Please select a mood');
      return;
    }

    // Get current date
    final now = DateTime.now();
    final formattedDate =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString().substring(2)}';

    // Generate unique ID
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    // Create reflection data
    final reflectionData = {
      'id': id,
      'text': reflectionController.text.trim(),
      'date': formattedDate,
      'moodImagePath': selectedMood.value,
    };

    // Add to daily reflection controller
    try {
      final dailyReflectionController = Get.find<DailyReflectionController>();
      dailyReflectionController.reflections.insert(0, reflectionData);
    } catch (e) {
      // If controller is not found, it will be initialized when screen loads
    }

    // Clear the form
    reflectionController.clear();
    selectedMood.value = '';

    // Show success message and navigate back
    Get.snackbar('Success', 'Reflection saved successfully');
    Get.offNamed(AppRoutes.dailyReflectionScreen);
  }

  @override
  void onClose() {
    if (isListening.value) {
      _speech.stop();
    }
    reflectionController.dispose();
    super.onClose();
  }
}
