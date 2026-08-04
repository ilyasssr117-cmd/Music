import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/video_model.dart';

/// Frosted-glass overlay drawn on top of a video tile: a floating action
/// sidebar on the right (like / comment / share / bookmark) and a bottom
/// glass panel showing the video title and author.
class GlassOverlayUI extends StatefulWidget {
  final VideoItem video;

  const GlassOverlayUI({super.key, required this.video});

  @override
  State<GlassOverlayUI> createState() => _GlassOverlayUIState();
}

class _GlassOverlayUIState extends State<GlassOverlayUI> {
  bool _isLiked = false;
  bool _isBookmarked = false;
  late int _likeCount = widget.video.likesCount;

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // Right side floating glass action sidebar.
          Positioned(
            right: 12,
            bottom: 110,
            child: _GlassPanel(
              borderRadius: 28,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ActionIcon(
                    icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                    label: _formatCount(_likeCount),
                    color: _isLiked ? Colors.redAccent : Colors.white,
                    onTap: _toggleLike,
                  ),
                  const SizedBox(height: 18),
                  _ActionIcon(
                    icon: Icons.mode_comment_outlined,
                    label: _formatCount(widget.video.commentsCount),
                    onTap: () {},
                  ),
                  const SizedBox(height: 18),
                  _ActionIcon(
                    icon: Icons.share_outlined,
                    label: 'Share',
                    onTap: () {},
                  ),
                  const SizedBox(height: 18),
                  _ActionIcon(
                    icon: _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    label: 'Save',
                    color: _isBookmarked ? Colors.amberAccent : Colors.white,
                    onTap: () => setState(() => _isBookmarked = !_isBookmarked),
                  ),
                ],
              ),
            ),
          ),

          // Bottom glass panel with title + author info.
          Positioned(
            left: 16,
            right: 90,
            bottom: 24,
            child: _GlassPanel(
              borderRadius: 24,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.video.authorName != null)
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white24,
                          backgroundImage: widget.video.authorAvatarUrl != null
                              ? NetworkImage(widget.video.authorAvatarUrl!)
                              : null,
                          child: widget.video.authorAvatarUrl == null
                              ? const Icon(Icons.person, size: 16, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.video.authorName!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 6),
                  Text(
                    widget.video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}

/// Reusable frosted-glass container: blurred backdrop, translucent white
/// fill, thin glowing border and rounded corners — the core building
/// block of the app's Glassmorphism theme.
class _GlassPanel extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;

  const _GlassPanel({
    required this.child,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.35),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
            ),
          ),
        ],
      ),
    );
  }
}
