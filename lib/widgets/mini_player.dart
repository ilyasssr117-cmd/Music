import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotiflac_android/providers/music_player_provider.dart';
import 'package:spotiflac_android/screens/now_playing_screen.dart';
import 'package:spotiflac_android/services/cover_cache_manager.dart';
import 'package:spotiflac_android/widgets/glass_surface.dart';
import 'package:spotiflac_android/widgets/settings_group.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaItem = ref.watch(currentMediaItemProvider).value;
    if (mediaItem == null) return const SizedBox.shrink();

    final playback = ref.watch(playbackStateProvider).value;
    final isPlaying = playback?.playing ?? false;
    final controller = ref.read(musicPlayerControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    final duration = mediaItem.duration?.inMilliseconds ?? 0;
    final position = playback?.position.inMilliseconds ?? 0;
    final progress = duration > 0 ? (position / duration).clamp(0.0, 1.0) : 0.0;

    return GlassSurface(
      margin: const EdgeInsets.fromLTRB(10, 6, 10, 8),
      borderRadius: BorderRadius.circular(28),
      blurSigma: 26,
      tint: settingsGroupColor(context),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute<void>(
                builder: (_) => const NowPlayingScreen(),
                fullscreenDialog: true,
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 3,
                  backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: SizedBox(
                        width: 46,
                        height: 46,
                        child: _MiniArt(
                          artUri: mediaItem.artUri?.toString(),
                          colorScheme: colorScheme,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            mediaItem.title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.2,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            mediaItem.artist ?? '',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    _MiniActionButton(
                      icon: isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      onPressed: () => controller.togglePlayPause(isPlaying),
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(width: 6),
                    _MiniActionButton(
                      icon: Icons.skip_next_rounded,
                      onPressed: controller.next,
                      colorScheme: colorScheme,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final ColorScheme colorScheme;

  const _MiniActionButton({
    required this.icon,
    required this.onPressed,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colorScheme.primary.withValues(alpha: 0.12),
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: 24,
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints.tightFor(width: 44, height: 44),
        style: IconButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _MiniArt extends StatelessWidget {
  final String? artUri;
  final ColorScheme colorScheme;

  const _MiniArt({required this.artUri, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.music_note_rounded,
        size: 22,
        color: colorScheme.onSurfaceVariant,
      ),
    );
    final uri = artUri;
    if (uri == null || uri.isEmpty) return placeholder;
    if (uri.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: uri,
        fit: BoxFit.cover,
        cacheManager: CoverCacheManager.instance,
        memCacheWidth: 132,
        fadeInDuration: const Duration(milliseconds: 150),
        fadeOutDuration: const Duration(milliseconds: 0),
        placeholder: (_, _) => placeholder,
        errorWidget: (_, _, _) => placeholder,
      );
    }
    if (uri.startsWith('file://')) {
      return Image.file(
        File(Uri.parse(uri).toFilePath()),
        fit: BoxFit.cover,
        cacheWidth: 132,
        errorBuilder: (_, _, _) => placeholder,
      );
    }
    return placeholder;
  }
}
