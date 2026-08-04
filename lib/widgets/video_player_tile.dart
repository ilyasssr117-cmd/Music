import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/video_model.dart';
import 'glass_overlay_ui.dart';

/// A single full-screen video tile inside the vertical feed.
///
/// Handles its own [VideoPlayerController] lifecycle: it only
/// initializes/plays the network video when [isActive] is true, and
/// pauses + disposes it as soon as it scrolls off-screen to keep memory
/// and battery usage under control.
class VideoPlayerTile extends StatefulWidget {
  final VideoItem video;
  final bool isActive;

  const VideoPlayerTile({
    super.key,
    required this.video,
    required this.isActive,
  });

  @override
  State<VideoPlayerTile> createState() => _VideoPlayerTileState();
}

class _VideoPlayerTileState extends State<VideoPlayerTile> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    if (widget.isActive) {
      _initializeController();
    }
  }

  @override
  void didUpdateWidget(covariant VideoPlayerTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _initializeController();
    } else if (!widget.isActive && oldWidget.isActive) {
      _disposeController();
    }
  }

  Future<void> _initializeController() async {
    if (widget.video.url.isEmpty) {
      setState(() => _hasError = true);
      return;
    }
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.video.url),
    );
    _controller = controller;
    try {
      await controller.initialize();
      controller.setLooping(true);
      if (!mounted) {
        // The tile was disposed while we were awaiting initialization.
        controller.dispose();
        return;
      }
      setState(() => _isInitialized = true);
      if (widget.isActive) {
        controller.play();
      }
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  void _disposeController() {
    final controller = _controller;
    _controller = null;
    _isInitialized = false;
    if (controller != null) {
      controller.pause();
      controller.dispose();
    }
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // --- Video / thumbnail / loading layer ---
        _buildVideoLayer(),

        // --- Bottom gradient scrim so text stays legible ---
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.55),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),
        ),

        // --- Glass overlay controls (sidebar + bottom info) ---
        GlassOverlayUI(video: widget.video),
      ],
    );
  }

  Widget _buildVideoLayer() {
    if (_hasError) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Icon(Icons.error_outline, color: Colors.white54, size: 40),
        ),
      );
    }

    final controller = _controller;

    if (controller != null && _isInitialized) {
      return GestureDetector(
        onTap: () {
          setState(() {
            controller.value.isPlaying ? controller.pause() : controller.play();
          });
        },
        child: FittedBox(
          fit: BoxFit.cover,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: controller.value.size.width,
            height: controller.value.size.height,
            child: VideoPlayer(controller),
          ),
        ),
      );
    }

    // Buffering / not-yet-active state: show thumbnail (if any) + spinner.
    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.video.thumbnailUrl != null)
          Image.network(
            widget.video.thumbnailUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.black),
          )
        else
          Container(color: Colors.black),
        const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
          ),
        ),
      ],
    );
  }
}
