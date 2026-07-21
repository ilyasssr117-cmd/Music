import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotiflac_android/l10n/l10n.dart';
import 'package:spotiflac_android/models/track.dart';
import 'package:spotiflac_android/providers/download_queue_provider.dart';
import 'package:spotiflac_android/providers/local_library_provider.dart';
import 'package:spotiflac_android/providers/playback_provider.dart';
import 'package:spotiflac_android/providers/preview_player_provider.dart';
import 'package:spotiflac_android/services/history_database.dart';
import 'package:spotiflac_android/utils/file_access.dart';

Future<bool> playTrackOrPreview(
  BuildContext context,
  WidgetRef ref,
  Track track,
) async {
  try {
    final historyNotifier = ref.read(downloadHistoryProvider.notifier);

    DownloadHistoryItem? historyItem = await historyNotifier
        .getBySpotifyIdAsync(track.id);
    final isrc = track.isrc?.trim();
    historyItem ??= (isrc != null && isrc.isNotEmpty)
        ? await historyNotifier.getByIsrcAsync(isrc)
        : null;
    historyItem ??= await historyNotifier.findByTrackAndArtistAsync(
      track.name,
      track.artistName,
    );

    if (historyItem != null) {
      final exists = await fileExists(historyItem.filePath);
      if (exists) {
        await ref.read(playbackProvider.notifier).playLocalPath(
              path: historyItem.filePath,
              title: track.name,
              artist: track.artistName,
              album: track.albumName,
              coverUrl: track.coverUrl ?? '',
            );
        return true;
      }
      historyNotifier.removeFromHistory(historyItem.id);
    }

    final localItem = await ref
        .read(localLibraryProvider.notifier)
        .findExistingAsync(
          isrc: isrc,
          trackName: track.name,
          artistName: track.artistName,
        );

    if (localItem != null && await fileExists(localItem.filePath)) {
      await ref.read(playbackProvider.notifier).playLocalPath(
            path: localItem.filePath,
            title: localItem.trackName,
            artist: localItem.artistName,
            album: localItem.albumName,
            coverUrl: localItem.coverPath ?? track.coverUrl ?? '',
          );
      return true;
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.snackbarCannotOpenFile('$e'))),
      );
    }
    return true;
  }

  if (track.hasPreview && (track.previewUrl?.trim().isNotEmpty ?? false)) {
    try {
      await ref.read(previewPlayerProvider.notifier).toggle(track.previewUrl);
      return true;
    } catch (_) {
      // Fall through to the snackbar below.
    }
  }

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.previewUnavailable)),
    );
  }
  return false;
}
