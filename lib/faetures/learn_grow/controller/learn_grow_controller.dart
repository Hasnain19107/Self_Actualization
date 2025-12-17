import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_exports.dart';

import '../../../data/repository/learn_grow_repository.dart';
import '../../../data/models/audio/audio_model.dart';
import '../../../data/models/learn_and_grow/video_model.dart';
import '../../../data/models/learn_and_grow/article_model.dart';

class LearnGrowController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // QuestionId for filtering content
  final RxString questionId = ''.obs;
  
  // Title from API response
  final RxString learningTitle = ''.obs;

  // Selected filter tab
  final RxString selectedTab = 'Audios'.obs;

  // Filter tabs
  final List<Map<String, dynamic>> filterTabs = [
    {'name': 'Audios', 'icon': Icons.graphic_eq},
    {'name': 'Articles', 'icon': Icons.article},
    {'name': 'Videos', 'icon': Icons.play_circle_outline},
  ];

  final RxList<AudioModel> audioFiles = <AudioModel>[].obs;
  final RxString selectedAudioId = ''.obs;
  final RxList<VideoModel> videoFiles = <VideoModel>[].obs;
  final RxList<ArticleModel> articleFiles = <ArticleModel>[].obs;
  final RxBool isLoadingAudios = false.obs;
  final RxBool isLoadingVideos = false.obs;
  final RxBool isLoadingArticles = false.obs;

  // Search query
  final RxString searchQuery = ''.obs;

  // UI state for audio playback (tracked separately since models are immutable)
  final RxMap<String, RxString> audioCurrentTime = <String, RxString>{}.obs;
  final RxMap<String, RxString> audioTotalDuration = <String, RxString>{}.obs;
  final RxMap<String, RxBool> audioIsPlaying = <String, RxBool>{}.obs;

  // Filtered lists based on search query
  List<AudioModel> get filteredAudios {
    if (searchQuery.value.isEmpty) {
      return audioFiles;
    }
    final query = searchQuery.value.toLowerCase();
    return audioFiles.where((audio) {
      return audio.title.toLowerCase().contains(query) ||
          audio.description.toLowerCase().contains(query) ||
          audio.category.toLowerCase().contains(query);
    }).toList();
  }

  List<VideoModel> get filteredVideos {
    if (searchQuery.value.isEmpty) {
      return videoFiles;
    }
    final query = searchQuery.value.toLowerCase();
    return videoFiles.where((video) {
      return video.title.toLowerCase().contains(query) ||
          video.description.toLowerCase().contains(query) ||
          video.category.toLowerCase().contains(query);
    }).toList();
  }

  List<ArticleModel> get filteredArticles {
    if (searchQuery.value.isEmpty) {
      return articleFiles;
    }
    final query = searchQuery.value.toLowerCase();
    return articleFiles.where((article) {
      return article.title.toLowerCase().contains(query) ||
          article.content.toLowerCase().contains(query) ||
          article.category.toLowerCase().contains(query);
    }).toList();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  @override
  void onInit() {
    super.onInit();
    // Get questionId from arguments if provided
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      final qId = arguments['questionId'] as String?;
      if (qId != null && qId.isNotEmpty) {
        questionId.value = qId;
        _fetchContentByQuestionId(qId);
        return; // Don't fetch all content if filtering by questionId
      }
    }
    // If no questionId, fetch all content as before
    _initializeAudioFiles();
    _initializeVideoFiles();
    _initializeArticleFiles();
    _setupAudioPlayerListeners();
  }

  /// Fetch all content (audios, videos, articles) by questionId
  Future<void> _fetchContentByQuestionId(String qId) async {
    isLoadingAudios.value = true;
    isLoadingVideos.value = true;
    isLoadingArticles.value = true;
    
    try {
      final response = await LearnGrowRepository().getAllContentByQuestionId(qId);
      
      if (response.success && response.data != null) {
        final data = response.data!;
        
        // Extract title from API response
        // The API returns: { "success": true, "data": { "title": "...", ... } }
        // ApiResponseModel extracts the inner "data" object, so data is already the inner object
        final title = data['title'] as String?;
        if (title != null && title.isNotEmpty) {
          learningTitle.value = title;
        }
        
        // Parse audios
        if (data['audios'] != null && data['audios'] is List) {
          audioFiles.value = (data['audios'] as List)
              .map((item) => AudioModel.fromJson(item as Map<String, dynamic>))
              .toList();
          // Initialize UI state for each audio
          for (var audio in audioFiles) {
            audioCurrentTime[audio.id] = '00:00'.obs;
            audioTotalDuration[audio.id] = '00:00'.obs;
            audioIsPlaying[audio.id] = false.obs;
            _fetchDurationFromUrl(audio.id, audio.audioUrl);
          }
        }
        
        // Parse videos
        if (data['videos'] != null && data['videos'] is List) {
          videoFiles.value = (data['videos'] as List)
              .map((item) => VideoModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        
        // Parse articles
        if (data['articles'] != null && data['articles'] is List) {
          articleFiles.value = (data['articles'] as List)
              .map((item) => ArticleModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        
        _setupAudioPlayerListeners();
      } else {
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to load content',
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastClass.showCustomToast(
        'Error loading content: ${e.toString()}',
        type: ToastType.error,
      );
    } finally {
      isLoadingAudios.value = false;
      isLoadingVideos.value = false;
      isLoadingArticles.value = false;
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  void _setupAudioPlayerListeners() {
    // Listen to position changes
    _audioPlayer.onPositionChanged.listen((duration) {
      if (selectedAudioId.value.isNotEmpty) {
        final audioId = selectedAudioId.value;
        if (audioCurrentTime.containsKey(audioId)) {
          final minutes = duration.inMinutes;
          final seconds = duration.inSeconds % 60;
          audioCurrentTime[audioId]!.value =
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        }
      }
    });

    // Listen to player state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (selectedAudioId.value.isNotEmpty) {
        final audioId = selectedAudioId.value;
        if (audioIsPlaying.containsKey(audioId)) {
          audioIsPlaying[audioId]!.value = state == PlayerState.playing;
        }
      }
    });

    // Listen to duration changes (when audio loads, get actual duration from URL)
    _audioPlayer.onDurationChanged.listen((duration) {
      if (selectedAudioId.value.isNotEmpty && duration != Duration.zero) {
        final audioId = selectedAudioId.value;
        if (audioTotalDuration.containsKey(audioId)) {
          final minutes = duration.inMinutes;
          final seconds = duration.inSeconds % 60;
          audioTotalDuration[audioId]!.value =
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        }
      }
    });

    // Listen for audio completion and restart from beginning
    _audioPlayer.onPlayerComplete.listen((_) {
      if (selectedAudioId.value.isNotEmpty) {
        // Reset to beginning and play again
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.resume();
      }
    });
  }

  Future<void> _initializeAudioFiles() async {
    isLoadingAudios.value = true;
    try {
      final response = await LearnGrowRepository().getAudios(page: 1, limit: 20);

      if (response.success && response.data != null) {
        audioFiles.value = response.data!;
        // Initialize UI state for each audio
        // Note: We don't use API's durationSeconds - duration is fetched from actual audio file URL
        for (var audio in audioFiles) {
          audioCurrentTime[audio.id] = '00:00'.obs;
          audioTotalDuration[audio.id] = '00:00'.obs;
          audioIsPlaying[audio.id] = false.obs;
          
          // Fetch duration from URL without playing
          _fetchDurationFromUrl(audio.id, audio.audioUrl);
        }
      } else {
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to load audios',
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastClass.showCustomToast(
        'Error loading audios: ${e.toString()}',
        type: ToastType.error,
      );
    } finally {
      isLoadingAudios.value = false;
    }
  }

  /// Fetch duration from audio URL without playing
  Future<void> _fetchDurationFromUrl(String audioId, String audioUrl) async {
    try {
      // Create a temporary player instance to get duration
      final tempPlayer = AudioPlayer();
      
      // Listen to duration changes
      final completer = Completer<Duration>();
      late StreamSubscription subscription;
      
      subscription = tempPlayer.onDurationChanged.listen((duration) {
        if (duration != Duration.zero && !completer.isCompleted) {
          completer.complete(duration);
        }
      });
      
      // Set the source
      await tempPlayer.setSource(UrlSource(audioUrl));
      
      // Wait for duration with timeout
      final duration = await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => Duration.zero,
      );
      
      // Cancel subscription
      await subscription.cancel();
      
      // Update duration if valid
      if (duration != Duration.zero && audioTotalDuration.containsKey(audioId)) {
        final minutes = duration.inMinutes;
        final seconds = duration.inSeconds % 60;
        audioTotalDuration[audioId]!.value =
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      }
      
      // Dispose the temporary player
      await tempPlayer.dispose();
    } catch (e) {
      // If fetching duration fails, it will be updated when audio is played
      DebugUtils.logWarning(
        'Failed to fetch duration for audio $audioId: ${e.toString()}',
        tag: 'LearnGrowController._fetchDurationFromUrl',
      );
    }
  }

  Future<void> _initializeVideoFiles() async {
    isLoadingVideos.value = true;
    try {
      final response = await LearnGrowRepository().getVideos(page: 1, limit: 20);

      if (response.success && response.data != null) {
        videoFiles.value = response.data!;
      } else {
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to load videos',
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastClass.showCustomToast(
        'Error loading videos: ${e.toString()}',
        type: ToastType.error,
      );
    } finally {
      isLoadingVideos.value = false;
    }
  }

  Future<void> _initializeArticleFiles() async {
    isLoadingArticles.value = true;
    try {
      final response = await LearnGrowRepository().getArticles(page: 1, limit: 20);

      if (response.success && response.data != null) {
        articleFiles.value = response.data!;
      } else {
        ToastClass.showCustomToast(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to load articles',
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastClass.showCustomToast(
        'Error loading articles: ${e.toString()}',
        type: ToastType.error,
      );
    } finally {
      isLoadingArticles.value = false;
    }
  }
  
  void selectTab(String tabName) {
    selectedTab.value = tabName;
  }

  Future<void> toggleAudio(String audioId) async {
    try {
      final audio = audioFiles.firstWhereOrNull((a) => a.id == audioId);
      if (audio == null) return;

      // If clicking the same audio, toggle play/pause
      if (selectedAudioId.value == audioId) {
        if (audioIsPlaying[audioId]?.value ?? false) {
          // Pause
          await _audioPlayer.pause();
        } else {
          // Resume
          await _audioPlayer.resume();
        }
      } else {
        // Stop current audio if playing
        if (selectedAudioId.value.isNotEmpty) {
          await _audioPlayer.stop();
          final currentAudioId = selectedAudioId.value;
          if (audioIsPlaying.containsKey(currentAudioId)) {
            audioIsPlaying[currentAudioId]!.value = false;
          }
          if (audioCurrentTime.containsKey(currentAudioId)) {
            audioCurrentTime[currentAudioId]!.value = '00:00';
          }
        }

        // Select new audio and start playing
        selectedAudioId.value = audioId;
        for (var a in audioFiles) {
          if (audioIsPlaying.containsKey(a.id)) {
            audioIsPlaying[a.id]!.value = a.id == audioId;
          }
        }

        // Start playing the new audio
        await _audioPlayer.play(UrlSource(audio.audioUrl));
      }
    } catch (e) {
      ToastClass.showCustomToast(
        'Error playing audio: ${e.toString()}',
        type: ToastType.error,
      );
    }
  }

  // Helper methods to get UI state for audio
  String getAudioCurrentTime(String audioId) {
    return audioCurrentTime[audioId]?.value ?? '00:00';
  }

  String getAudioTotalDuration(String audioId) {
    return audioTotalDuration[audioId]?.value ?? '00:00';
  }

  bool isAudioPlaying(String audioId) {
    return audioIsPlaying[audioId]?.value ?? false;
  }

  // Helper method to get emoji based on category
  String getEmojiForCategory(String category) {
    final lowerCategory = category.toLowerCase();
    if (lowerCategory.contains('motivation')) {
      return '🧘‍♂️';
    } else if (lowerCategory.contains('meditation')) {
      return '🧘‍♀️';
    } else if (lowerCategory.contains('focus')) {
      return '👊';
    } else if (lowerCategory.contains('calm')) {
      return '🧘‍♀️';
    }
    return '🎵';
  }
}
