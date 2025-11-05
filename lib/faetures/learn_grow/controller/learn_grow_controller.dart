import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Audio file data model
class AudioFile {
  final String id;
  final String title;
  final String emoji;
  final String currentTime;
  final String totalDuration;
  final RxBool isPlaying;

  AudioFile({
    required this.id,
    required this.title,
    required this.emoji,
    required this.currentTime,
    required this.totalDuration,
    required this.isPlaying,
  });
}

// Video file data model
class VideoFile {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final String duration;

  VideoFile({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.duration,
  });
}

class LearnGrowController extends GetxController {
  // Selected filter tab
  final RxString selectedTab = 'Audios'.obs;

  // Filter tabs
  final List<Map<String, dynamic>> filterTabs = [
    {'name': 'Audios', 'icon': Icons.graphic_eq},
    {'name': 'Articles', 'icon': Icons.article},
    {'name': 'Videos', 'icon': Icons.play_circle_outline},
  ];

  final RxList<AudioFile> audioFiles = <AudioFile>[].obs;
  final RxString selectedAudioId = ''.obs;
  final RxList<VideoFile> videoFiles = <VideoFile>[].obs;
  final RxList<VideoFile> articleFiles = <VideoFile>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAudioFiles();
    _initializeVideoFiles();
    _initializeArticleFiles();
  }

  void _initializeAudioFiles() {
    audioFiles.value = [
      AudioFile(
        id: '1',
        title: 'Daily Motivation',
        emoji: '🧘‍♂️',
        currentTime: '3:20',
        totalDuration: '10:12',
        isPlaying: false.obs,
      ),
      AudioFile(
        id: '2',
        title: 'Daily Motivation',
        emoji: '👊',
        currentTime: '3:20',
        totalDuration: '10:12',
        isPlaying: true.obs,
      ),
      AudioFile(
        id: '3',
        title: 'Daily Motivation',
        emoji: '🧘‍♂️',
        currentTime: '3:20',
        totalDuration: '10:12',
        isPlaying: false.obs,
      ),
      AudioFile(
        id: '4',
        title: 'Daily Motivation',
        emoji: '🧘‍♂️',
        currentTime: '3:20',
        totalDuration: '10:12',
        isPlaying: false.obs,
      ),
    ];
    selectedAudioId.value = '2'; // Second audio is selected/playing
  }

  void _initializeVideoFiles() {
    videoFiles.value = [
      VideoFile(
        id: '1',
        title: 'Calm the Racing Mind',
        description: 'Immerse yourself in peace and harmony with this...',
        emoji: '🧘‍♀️',
        duration: '8 min',
      ),
      VideoFile(
        id: '2',
        title: 'Calm the Racing Mind',
        description: 'Immerse yourself in peace and harmony with this...',
        emoji: '🧘‍♀️',
        duration: '8 min',
      ),
      VideoFile(
        id: '3',
        title: 'Calm the Racing Mind',
        description: 'Immerse yourself in peace and harmony with this...',
        emoji: '🧘‍♀️',
        duration: '8 min',
      ),
    ];
  }

  void _initializeArticleFiles() {
    articleFiles.value = [
      VideoFile(
        id: '1',
        title: 'Calm the Racing Mind',
        description: 'Immerse yourself in peace and harmony with this...',
        emoji: '🧘‍♀️',
        duration: '8 min',
      ),
      VideoFile(
        id: '2',
        title: 'Calm the Racing Mind',
        description: 'Immerse yourself in peace and harmony with this...',
        emoji: '🧘‍♀️',
        duration: '8 min',
      ),
      VideoFile(
        id: '3',
        title: 'Calm the Racing Mind',
        description: 'Immerse yourself in peace and harmony with this...',
        emoji: '🧘‍♀️',
        duration: '8 min',
      ),
    ];
  }

  void selectTab(String tabName) {
    selectedTab.value = tabName;
  }

  void toggleAudio(String audioId) {
    // If clicking the same audio, toggle play/pause
    if (selectedAudioId.value == audioId) {
      final audio = audioFiles.firstWhereOrNull((a) => a.id == audioId);
      if (audio != null) {
        audio.isPlaying.value = !audio.isPlaying.value;
      }
    } else {
      // Select new audio and pause others
      selectedAudioId.value = audioId;
      for (var audio in audioFiles) {
        audio.isPlaying.value = audio.id == audioId;
      }
    }
  }
}
