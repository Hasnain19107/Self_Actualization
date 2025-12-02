import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../core/const/app_exports.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String description;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.description,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );

      await _controller.initialize();
      _controller.addListener(_videoListener);

      setState(() {
        _isInitialized = true;
        _isLoading = false;
        _isPlaying = _controller.value.isPlaying;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ToastClass.showCustomToast(
          'Error loading video: ${e.toString()}',
          type: ToastType.error,
        );
      }
    }
  }

  void _videoListener() {
    if (_controller.value.isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });
    }
  }

  Future<void> _togglePlayPause() async {
    if (!_isInitialized) return;

    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      await _controller.play();
    } else {
      await _controller.pause();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  Future<void> _toggleFullscreen() async {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });

    if (_isFullscreen) {
      // Enter fullscreen - lock to landscape
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      // Exit fullscreen - allow all orientations
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  void dispose() {
    // Restore orientation when leaving
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header with back button (hidden in fullscreen)
                if (!_isFullscreen)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: AppColors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextWidget(
                                text: widget.title,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                textColor: AppColors.white,
                                maxLines: 1,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              CustomTextWidget(
                                text: widget.description,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                textColor: AppColors.white.withOpacity(0.7),
                                maxLines: 1,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

            // Video player
            Expanded(
              child: Center(
                child: _isLoading
                    ? const CustomProgressIndicator(
                        color: AppColors.white,
                      )
                    : _isInitialized
                        ? GestureDetector(
                            onTap: _togglePlayPause,
                            child: Stack(
                              alignment: Alignment.center,
                              fit: _isFullscreen ? StackFit.expand : StackFit.loose,
                              children: [
                                AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                ),
                                // Play/Pause overlay
                                if (!_isPlaying)
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: AppColors.black.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow,
                                      color: AppColors.white,
                                      size: 48,
                                    ),
                                  ),
                                // Video controls overlay
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          AppColors.black.withOpacity(0.8),
                                          AppColors.black.withOpacity(0.0),
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Progress bar
                                        VideoProgressIndicator(
                                          _controller,
                                          allowScrubbing: true,
                                          colors: const VideoProgressColors(
                                            playedColor: AppColors.blue,
                                            bufferedColor: AppColors.white,
                                            backgroundColor: AppColors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Time and controls
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomTextWidget(
                                              text:
                                                  '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              textColor: AppColors.white,
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: _togglePlayPause,
                                                  icon: Icon(
                                                    _isPlaying
                                                        ? Icons.pause
                                                        : Icons.play_arrow,
                                                    color: AppColors.white,
                                                    size: 32,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: _toggleFullscreen,
                                                  icon: Icon(
                                                    _isFullscreen
                                                        ? Icons.fullscreen_exit
                                                        : Icons.fullscreen,
                                                    color: AppColors.white,
                                                    size: 28,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : CustomTextWidget(
                            text: 'Failed to load video',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            textColor: AppColors.white,
                          ),
              ),
            ),
              ],
            ),
            // Back button in fullscreen mode (top left corner)
            if (_isFullscreen)
              Positioned(
                top: 16,
                left: 16,
                child: GestureDetector(
                  onTap: () async {
                    await _toggleFullscreen();
                    Get.back();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

