/// A flexible data model representing a single video item in the feed.
///
/// Only [title] and [url] (the playable video stream URL) are treated as
/// mandatory fields. Every other field is optional so this model can be
/// mapped to virtually any backend / JSON schema without breaking.
///
/// Any extra keys present in the source JSON that are not explicitly
/// modeled here are preserved inside [raw], so you can extend the UI
/// later without touching this class.
class VideoItem {
  /// Unique identifier. Falls back to the video [url] if the backend
  /// doesn't provide one, so it can still be used as a stable key.
  final String id;

  /// Mandatory: the caption / headline shown over the video.
  final String title;

  /// Mandatory: the direct video stream URL (mp4, hls, etc).
  final String url;

  /// Optional: thumbnail / poster image shown while the video buffers.
  final String? thumbnailUrl;

  /// Optional: number of likes, defaults to 0 when missing.
  final int likesCount;

  /// Optional: number of comments, defaults to 0 when missing.
  final int commentsCount;

  /// Optional: display name of the video author / creator.
  final String? authorName;

  /// Optional: avatar image of the author.
  final String? authorAvatarUrl;

  /// Keeps a copy of the untouched original JSON in case the UI needs
  /// to read a field that isn't explicitly modeled above.
  final Map<String, dynamic> raw;

  VideoItem({
    required this.title,
    required this.url,
    String? id,
    this.thumbnailUrl,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.authorName,
    this.authorAvatarUrl,
    Map<String, dynamic>? raw,
  })  : id = id ?? url,
        raw = raw ?? const {};

  /// Builds a [VideoItem] out of a loosely-structured JSON map.
  ///
  /// This is intentionally defensive: it tries a handful of common key
  /// aliases for each field (e.g. `videoUrl`, `video_url`, `url`) so it
  /// plays nicely with many different API shapes without any backend
  /// specific assumptions.
  factory VideoItem.fromJson(Map<String, dynamic> json) {
    String? _firstString(List<String> keys) {
      for (final k in keys) {
        final v = json[k];
        if (v is String && v.trim().isNotEmpty) return v;
      }
      return null;
    }

    int _firstInt(List<String> keys) {
      for (final k in keys) {
        final v = json[k];
        if (v is int) return v;
        if (v is String) {
          final parsed = int.tryParse(v);
          if (parsed != null) return parsed;
        }
      }
      return 0;
    }

    final title = _firstString(['title', 'caption', 'name']) ?? 'Untitled';
    final url = _firstString(['url', 'videoUrl', 'video_url', 'src']) ?? '';

    return VideoItem(
      id: _firstString(['id', '_id', 'videoId']),
      title: title,
      url: url,
      thumbnailUrl: _firstString(['thumbnailUrl', 'thumbnail_url', 'thumbnail', 'poster']),
      likesCount: _firstInt(['likesCount', 'likes_count', 'likes']),
      commentsCount: _firstInt(['commentsCount', 'comments_count', 'comments']),
      authorName: _firstString(['authorName', 'author_name', 'author', 'username']),
      authorAvatarUrl: _firstString(['authorAvatarUrl', 'author_avatar_url', 'avatar']),
      raw: json,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'url': url,
        'thumbnailUrl': thumbnailUrl,
        'likesCount': likesCount,
        'commentsCount': commentsCount,
        'authorName': authorName,
        'authorAvatarUrl': authorAvatarUrl,
      };
}
