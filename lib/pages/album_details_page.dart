import 'package:flutter/material.dart';
import 'package:maleva_spins/models/collection_item.dart';
import 'package:maleva_spins/services/listening_timer_service.dart';

class AlbumDetailsPage extends StatelessWidget {
  final CollectionItem album;

  const AlbumDetailsPage({super.key, required this.album});

  Future<void> _startListening(BuildContext context) async {
    final timerService = ListeningTimerService();

    await timerService.startListening(
      albumId: album.id.toString(),
      albumTitle: album.basicInfo.title,
      artistName: album.basicInfo.artists.map((a) => a.name).join(', '),
      coverImage: album.basicInfo.coverImage ?? album.basicInfo.thumb,
    );

    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Começou a ouvir "${album.basicInfo.title}"'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerService = ListeningTimerService();
    final isCurrentlyPlaying =
        timerService.isPlaying &&
        timerService.currentSession?.albumId == album.id.toString();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Hero(
              tag: 'album_${album.id}',
              child: Image.network(
                album.basicInfo.coverImage ?? album.basicInfo.thumb ?? '',
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(opacity: value, child: child);
                    },
                    child: Text(
                      album.basicInfo.title,
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(opacity: value, child: child);
                    },
                    child: Text(
                      album.basicInfo.artists.map((a) => a.name).join(', '),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 8),

                  if (album.basicInfo.year > 0)
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(opacity: value, child: child);
                      },
                      child: Text(
                        album.basicInfo.year.toString(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),

                  const SizedBox(height: 32),

                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Opacity(opacity: value, child: child),
                      );
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: isCurrentlyPlaying
                            ? null
                            : () => _startListening(context),
                        icon: Icon(
                          isCurrentlyPlaying
                              ? Icons.play_arrow
                              : Icons.play_arrow,
                        ),
                        label: Text(
                          isCurrentlyPlaying
                              ? 'Tocando agora'
                              : 'Começar a ouvir',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isCurrentlyPlaying
                              ? Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest
                              : Theme.of(context).colorScheme.primary,
                          foregroundColor: isCurrentlyPlaying
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
