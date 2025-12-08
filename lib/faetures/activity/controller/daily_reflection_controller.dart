import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../core/const/app_exports.dart';

import '../../../data/repository/reflection_repository.dart';
import '../../../data/models/reflection/reflection_request_model.dart';

class DailyReflectionController extends GetxController {
  // Add Reflection fields
  final TextEditingController reflectionController = TextEditingController();
  final RxString selectedMood = ''.obs;
  final RxInt characterCount = 0.obs;
  final int maxCharacters = 300;
  final RxBool isLoading = false.obs;

  final ReflectionRepository _reflectionRepository = ReflectionRepository();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final RxBool isListening = false.obs;
  final RxBool isAvailable = false.obs;

  // Mood emojis for selection (6 moods matching API: angry, anxious, sad, stressed, neutral, happy)
  final List<Map<String, dynamic>> moodOptions = [
    {
      'imagePath': AppImages.sleepEmoji,
      'mood': 'stressed',
    }, // Orange - stressed/tired
    {
      'imagePath': AppImages.teethEmoji,      
      'mood': 'anxious',
    }, // Yellow - anxious
    {
      'imagePath': AppImages.silentEmoji,
   
      'mood': 'sad',
    }, // Light Blue - sad
    {
      'imagePath': AppImages.wonderEmoji,
      
      'mood': 'neutral',
    }, // Light Pink - neutral/wondering
    {
      'imagePath': AppImages.hardEmoji,
      
      'mood': 'angry',
    }, // Dark Blue - angry
    {
      'imagePath': AppImages.happyEmoji,
     
      'mood': 'happy',
    }, // Yellow - happy
  ];
  
  // Get mood string from selected mood image path
  String? _getMoodString(String imagePath) {
    final moodOption = moodOptions.firstWhereOrNull(
      (mood) => mood['imagePath'] == imagePath,
    );
    return moodOption?['mood'] as String?;
  }

  // Reflection entries data (loaded from API)
  final RxList<Map<String, dynamic>> reflections = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingReflections = false.obs;

  @override
  void onInit() {
    super.onInit();
    reflectionController.addListener(_updateCharacterCount);
    _initializeSpeech();
    fetchReflections();
  }

  // Fetch reflections from API
  Future<void> fetchReflections() async {
    try {
      isLoadingReflections.value = true;

      // Get start and end dates (from last Monday to today)
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      // Calculate last Monday (weekday: 1 = Monday, 7 = Sunday)
      final daysSinceMonday = (today.weekday - 1) % 7; // 0 for Monday, 6 for Sunday
      final startDate = today.subtract(Duration(days: daysSinceMonday)); // Last Monday
      final endDate = DateTime(now.year, now.month, now.day + 1); // Today + 1 day

      // Format dates as ISO 8601 strings
      final startDateString = startDate.toIso8601String();
      final endDateString = endDate.toIso8601String();

      final response = await _reflectionRepository.getReflections(
        startDate: startDateString,
        endDate: endDateString,
      );

      isLoadingReflections.value = false;

      if (response.success && response.data != null) {
        // Convert API reflections to local format
        reflections.value = response.data!.map((reflection) {
          // Format date for display
          final date = reflection.date;
          final formattedDate =
              '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}';

          // Map mood string to image path
          final moodImagePath = _getMoodImagePath(reflection.mood);

          return {
            'id': reflection.id,
            'text': reflection.note,
            'date': formattedDate,
            'dateTime': date, // Store DateTime for sorting and day calculation
            'moodImagePath': moodImagePath,
            'mood': reflection.mood,
          };
        }).toList();
      } else {
        DebugUtils.logWarning(
          'Failed to fetch reflections: ${response.message}',
          tag: 'DailyReflectionController._fetchReflections',
        );
      }
    } catch (e) {
      isLoadingReflections.value = false;
      DebugUtils.logError(
        'Error fetching reflections',
        tag: 'DailyReflectionController._fetchReflections',
        error: e,
      );
    }
  }

  // Get mood image path from mood string
  String _getMoodImagePath(String mood) {
    final moodOption = moodOptions.firstWhereOrNull(
      (option) => option['mood'] == mood,
    );
    return moodOption?['imagePath'] as String? ?? AppImages.hardEmoji;
  }

  // Get last 7 days reflections (one per day, most recent)
  List<Map<String, dynamic>> get last7DaysReflections {
    if (reflections.isEmpty) return [];

    // Get current date and find last Monday
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Calculate last Monday (weekday: 1 = Monday, 7 = Sunday)
    final daysSinceMonday = (today.weekday - 1) % 7; // 0 for Monday, 6 for Sunday
    final lastMonday = today.subtract(Duration(days: daysSinceMonday));
    
    // Create a map to store the most recent reflection for each day
    final Map<String, Map<String, dynamic>> dayReflectionsMap = {};
    
    // Process reflections and keep only the most recent one per day
    for (final reflection in reflections) {
      // Try to get dateTime directly, otherwise parse from date string
      DateTime? reflectionDate;
      
      if (reflection['dateTime'] != null) {
        reflectionDate = reflection['dateTime'] as DateTime?;
      } else {
        // Fallback: parse date from format "DD/MM/YY"
        final dateStr = reflection['date'] as String?;
        if (dateStr == null) continue;
        
        final dateParts = dateStr.split('/');
        if (dateParts.length != 3) continue;
        
        try {
          final day = int.parse(dateParts[0]);
          final month = int.parse(dateParts[1]);
          final year = int.parse('20${dateParts[2]}'); // Convert YY to YYYY
          reflectionDate = DateTime(year, month, day);
        } catch (e) {
          continue;
        }
      }
      
      if (reflectionDate == null) continue;
      
      // Normalize to date only (remove time)
      final reflectionDay = DateTime(reflectionDate.year, reflectionDate.month, reflectionDate.day);
      
      // Check if within current week (from last Monday to today)
      if (reflectionDay.isBefore(lastMonday) || reflectionDay.isAfter(today)) continue;
      
      // Use date as key (YYYY-MM-DD format for uniqueness)
      final dateKey = '${reflectionDay.year}-${reflectionDay.month.toString().padLeft(2, '0')}-${reflectionDay.day.toString().padLeft(2, '0')}';
      
      // Keep only the most recent reflection for each day
      if (!dayReflectionsMap.containsKey(dateKey)) {
        dayReflectionsMap[dateKey] = {
          ...reflection,
          'dateTime': reflectionDate,
        };
      } else {
        // If we already have a reflection for this day, keep the one with later time
        final existing = dayReflectionsMap[dateKey]!;
        final existingDate = existing['dateTime'] as DateTime?;
        if (existingDate != null && reflectionDate.isAfter(existingDate)) {
          dayReflectionsMap[dateKey] = {
            ...reflection,
            'dateTime': reflectionDate,
          };
        }
      }
    }
    
    // Convert to list and sort by date (newest first)
    final sortedReflections = dayReflectionsMap.values.toList()
      ..sort((a, b) {
        final dateA = a['dateTime'] as DateTime?;
        final dateB = b['dateTime'] as DateTime?;
        if (dateA == null || dateB == null) return 0;
        return dateB.compareTo(dateA); // Newest first
      });
    
    // Take only last 7 days
    return sortedReflections.take(7).toList();
  }

  // Get moods with reflections for last 7 days (one per day)
  List<Map<String, dynamic>> get moodsWithReflections {
    final last7Days = last7DaysReflections;
    
    if (last7Days.isEmpty) return [];

    // Map each reflection to mood data with day label
    final moodsList = last7Days.map((reflection) {
      final mood = reflection['mood'] as String?;
      if (mood == null || mood.isEmpty) return null;
      
      final moodOption = moodOptions.firstWhereOrNull(
        (option) => option['mood'] == mood,
      );
      
      if (moodOption == null) return null;
      
      // Get day of week from date
      final dateTime = reflection['dateTime'] as DateTime?;
      String dayLabel = '';
      if (dateTime != null) {
        final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        dayLabel = dayNames[dateTime.weekday - 1];
      }
      
      return {
        'mood': mood,
        'imagePath': moodOption['imagePath'],
        'bgColor': moodOption['bgColor'],
        'day': dayLabel,
      };
    }).whereType<Map<String, dynamic>>().toList();

    return moodsList;
  }

  void _initializeSpeech() async {
    isAvailable.value = await _speech.initialize(
      onError: (error) {
        ToastClass.showCustomToast('Speech recognition error: ${error.errorMsg}', type: ToastType.error);
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
      ToastClass.showCustomToast('Speech recognition is not available', type: ToastType.error);
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
              ToastClass.showCustomToast('Character limit reached', type: ToastType.simple);
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

  Future<void> saveReflection() async {
    if (reflectionController.text.trim().isEmpty) {
      ToastClass.showCustomToast('Please write your reflection', type: ToastType.error);
      return;
    }
    if (selectedMood.value.isEmpty) {
      ToastClass.showCustomToast('Please select a mood', type: ToastType.error);
      return;
    }

    // Get mood string from selected mood image path
    final moodString = _getMoodString(selectedMood.value);
    if (moodString == null) {
      ToastClass.showCustomToast('Invalid mood selection', type: ToastType.error);
      return;
    }

    try {
      isLoading.value = true;

      // Create reflection request
      final request = ReflectionRequestModel(
        mood: moodString,
        note: reflectionController.text.trim(),
      );

      // Call API to save reflection
      final response = await _reflectionRepository.createReflection(request);

      isLoading.value = false;

      if (response.success) {
        // Get current date
        final now = DateTime.now();
        final formattedDate =
            '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString().substring(2)}';

        // Generate unique ID
        final id = DateTime.now().millisecondsSinceEpoch.toString();

        // Create reflection data for local storage
        final reflectionData = {
          'id': id,
          'text': reflectionController.text.trim(),
          'date': formattedDate,
          'dateTime': now, // Store DateTime for sorting and day calculation
          'moodImagePath': selectedMood.value,
          'mood': moodString,
        };

        // Add to reflections list
        reflections.insert(0, reflectionData);

        // Clear the form
        reflectionController.clear();
        selectedMood.value = '';

        // Show success message and navigate back
        ToastClass.showCustomToast(
          response.message.isNotEmpty ? response.message : 'Reflection saved successfully',
          type: ToastType.success,
        );
        
        // Refresh reflections from API to get the latest data
        fetchReflections();
        
        Get.offNamed(AppRoutes.dailyReflectionScreen);
      } else {
        ToastClass.showCustomToast(
          response.message.isNotEmpty ? response.message : 'Failed to save reflection',
          type: ToastType.error,
        );
      }
    } catch (e) {
      isLoading.value = false;
      ToastClass.showCustomToast(
        'Failed to save reflection. Please try again.',
        type: ToastType.error,
      );
    }
  }

  void addNewReflection() {
    Get.offNamed(AppRoutes.addReflectionScreen);
  }

  void viewReflectionHistory() {
    // Handle view full history
    ToastClass.showCustomToast('View full reflection history', type: ToastType.simple);
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
