import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotiflac_android/l10n/l10n.dart';
import 'package:spotiflac_android/models/track.dart';
import 'package:spotiflac_android/providers/playback_provider.dart';
import 'package:spotiflac_android/providers/preview_player_provider.dart';

Future<bool> playTrackLikeSpotify(
  BuildContext context,
  WidgetRef ref,
  Track track, {
  String? noPlayableSourceMessage,
}) async {
  try {
    await ref.read(playbackProvider.notifier).playTrackList([track]);
    return true;
  } catch (_) {
    // Ignore and fall back to preview playback below.
  }

  if (track.hasPreview) {
    try {
      await ref.read(previewPlayerProvider.notifier).toggle(track.previewUrl);
      return true;
    } catch (_) {
      // Fall through to the snackbar below.
    }
  }

  if (!context.mounted) {
    return false;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        noPlayableSourceMessage ??
            (track.hasPreview
                ? context.l10n.previewUnavailable
                : 'No playable source available. Download the track first.'),
      ),
    ),
  );
  return false;
}
