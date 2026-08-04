import 'dart:convert';
import '../models/video_model.dart';

/// Abstraction layer for all network calls related to the video feed.
///
/// This is intentionally backend-agnostic: swap [baseUrl] and the body
/// of [fetchVideos] with your real HTTP client (http, dio, graphql...)
/// whenever you plug in an actual backend. Until then it returns mock
/// data so the UI is testable out of the box.
class ApiService {
  /// Placeholder base URL — replace with your real API root.
  static const String baseUrl = 'https://api.example.com/v1';

  /// Placeholder endpoint — replace with your real videos endpoint.
  static const String videosEndpoint = '/videos';

  /// Fetches the list of videos to display in the feed.
  ///
  /// Currently returns mock data after a short simulated network delay.
  /// To wire up a real backend:
  /// 1. Uncomment the http call below.
  /// 2. Parse `response.body` as JSON (a List<dynamic>).
  /// 3. Map every element through `VideoItem.fromJson`.
  Future<List<VideoItem>> fetchVideos() async {
    // --- Real implementation sketch (uncomment & adapt) ---
    // final uri = Uri.parse('$baseUrl$videosEndpoint');
    // final response = await http.get(uri);
    // if (response.statusCode == 200) {
    //   final List<dynamic> body = jsonDecode(response.body);
    //   return body.map((e) => VideoItem.fromJson(e)).toList();
    // } else {
    //   throw Exception('Failed to load videos (${response.statusCode})');
    // }

    await Future.delayed(const Duration(milliseconds: 600));
    return _mockVideosJson.map((e) => VideoItem.fromJson(e)).toList();
  }

  /// Small set of public, freely-streamable sample .mp4 URLs so the UI
  /// can be tested immediately after copy-pasting this project.
  static final List<Map<String, dynamic>> _mockVideosJson = [
    {
      'id': '1',
      'title': 'Big Buck Bunny 🐰',
      'url':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'thumbnailUrl':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg',
      'likesCount': 12500,
      'commentsCount': 342,
      'authorName': '@bigbuckbunny',
    },
    {
      'id': '2',
      'title': 'Elephants Dream 🐘',
      'url':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      'thumbnailUrl':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg',
      'likesCount': 8420,
      'commentsCount': 210,
      'authorName': '@elephantsdream',
    },
    {
      'id': '3',
      'title': 'For Bigger Blazes 🔥',
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      'thumbnailUrl':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerBlazes.jpg',
      'likesCount': 5310,
      'commentsCount': 98,
      'authorName': '@chromecast',
    },
    {
      'id': '4',
      'title': 'For Bigger Escape 🚀',
      'url':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscape.mp4',
      'thumbnailUrl':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerEscape.jpg',
      'likesCount': 9871,
      'commentsCount': 421,
      'authorName': '@chromecast',
    },
    {
      'id': '5',
      'title': 'Sintel — Short Film 🎬',
      'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
      'thumbnailUrl':
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/Sintel.jpg',
      'likesCount': 15302,
      'commentsCount': 733,
      'authorName': '@sintel_movie',
    },
  ];
}
