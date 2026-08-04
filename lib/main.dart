import 'package:flutter/material.dart';
import 'models/video_model.dart';
import 'services/api_service.dart';
import 'widgets/video_player_tile.dart';
import 'widgets/glass_search_bar.dart';

void main() {
  runApp(const ReelsGlassApp());
}

class ReelsGlassApp extends StatelessWidget {
  const ReelsGlassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reels — Glassmorphism',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'SF Pro Display', // falls back to system default if absent
      ),
      home: const FeedScreen(),
    );
  }
}

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final ApiService _apiService = ApiService();
  final PageController _pageController = PageController();

  List<VideoItem> _videos = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final videos = await _apiService.fetchVideos();
      if (!mounted) return;
      setState(() {
        _videos = videos;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load videos.';
        _isLoading = false;
      });
    }
  }

  void _jumpToVideo(VideoItem video) {
    final index = _videos.indexWhere((v) => v.id == video.id);
    if (index != -1) {
      _pageController.jumpToPage(index);
      setState(() => _activeIndex = index);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // --- Vertical snap-scrolling video feed ---
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.white70),
            )
          else if (_errorMessage != null)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_errorMessage!, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _loadVideos,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          else if (_videos.isEmpty)
            const Center(
              child: Text('No videos available.', style: TextStyle(color: Colors.white70)),
            )
          else
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: _videos.length,
              onPageChanged: (index) => setState(() => _activeIndex = index),
              itemBuilder: (context, index) {
                return VideoPlayerTile(
                  key: ValueKey(_videos[index].id),
                  video: _videos[index],
                  isActive: index == _activeIndex,
                );
              },
            ),

          // --- Floating glass search bar on top of everything ---
          if (!_isLoading && _errorMessage == null && _videos.isNotEmpty)
            GlassSearchBar(
              allVideos: _videos,
              onVideoSelected: _jumpToVideo,
            ),
        ],
      ),
    );
  }
}
