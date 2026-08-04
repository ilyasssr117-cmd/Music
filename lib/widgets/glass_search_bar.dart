import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/video_model.dart';

/// Floating Glassmorphic search bar shown on top of the feed.
///
/// Expands into a frosted, animated results overlay that filters the
/// already-loaded [allVideos] locally by [VideoItem.title] — no extra
/// network calls needed.
class GlassSearchBar extends StatefulWidget {
  final List<VideoItem> allVideos;
  final void Function(VideoItem selected) onVideoSelected;

  const GlassSearchBar({
    super.key,
    required this.allVideos,
    required this.onVideoSelected,
  });

  @override
  State<GlassSearchBar> createState() => _GlassSearchBarState();
}

class _GlassSearchBarState extends State<GlassSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isExpanded = false;
  String _query = '';

  List<VideoItem> get _results {
    if (_query.trim().isEmpty) return const [];
    final q = _query.toLowerCase();
    return widget.allVideos
        .where((v) => v.title.toLowerCase().contains(q))
        .toList();
  }

  void _close() {
    _focusNode.unfocus();
    setState(() {
      _isExpanded = false;
      _query = '';
      _controller.clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSearchField(),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              child: _isExpanded ? _buildResultsPanel() : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.35), width: 1.2),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              const Icon(Icons.search, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    hintText: 'Search videos...',
                    hintStyle: TextStyle(color: Colors.white60),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onTap: () => setState(() => _isExpanded = true),
                  onChanged: (value) => setState(() => _query = value),
                ),
              ),
              if (_isExpanded)
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 20),
                  onPressed: _close,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsPanel() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 320),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
            ),
            child: _query.trim().isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Start typing to search by title…',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : _results.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'No matching videos found.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        itemCount: _results.length,
                        separatorBuilder: (_, __) =>
                            Divider(color: Colors.white.withOpacity(0.15), height: 1),
                        itemBuilder: (context, index) {
                          final video = _results[index];
                          return ListTile(
                            dense: true,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: video.thumbnailUrl != null
                                  ? Image.network(
                                      video.thumbnailUrl!,
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => _thumbFallback(),
                                    )
                                  : _thumbFallback(),
                            ),
                            title: Text(
                              video.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            subtitle: video.authorName != null
                                ? Text(
                                    video.authorName!,
                                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                                  )
                                : null,
                            onTap: () {
                              widget.onVideoSelected(video);
                              _close();
                            },
                          );
                        },
                      ),
          ),
        ),
      ),
    );
  }

  Widget _thumbFallback() => Container(
        width: 44,
        height: 44,
        color: Colors.white24,
        child: const Icon(Icons.movie_outlined, color: Colors.white70, size: 20),
      );
}
