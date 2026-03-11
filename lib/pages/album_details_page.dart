import 'package:flutter/material.dart';
import 'package:maleva_spins/models/collection_item.dart';
import 'package:maleva_spins/models/track.dart';
import 'package:maleva_spins/services/analytics_service.dart';
import 'package:maleva_spins/services/discogs_api_service.dart';
import 'package:maleva_spins/services/listening_timer_service.dart';

class AlbumDetailsPage extends StatefulWidget {
  final CollectionItem album;
  final DiscogsApiService apiService;

  const AlbumDetailsPage({
    super.key,
    required this.album,
    required this.apiService,
  });

  @override
  State<AlbumDetailsPage> createState() => _AlbumDetailsPageState();
}

class _AlbumDetailsPageState extends State<AlbumDetailsPage> {
  List<Track>? _tracklist;
  bool _loadingTracklist = true;

  @override
  void initState() {
    super.initState();
    _fetchTracklist();
    AnalyticsService().logAlbumViewed(
      albumId: widget.album.id.toString(),
      albumTitle: widget.album.basicInfo.title,
      artistName: widget.album.basicInfo.artists.map((a) => a.name).join(', '),
    );
  }

  Future<void> _fetchTracklist() async {
    try {
      final data = await widget.apiService.getRelease(widget.album.id);
      final rawTracks = data['tracklist'] as List?;
      if (mounted) {
        setState(() {
          _tracklist = rawTracks
              ?.map(
                (t) => Track(
                  title: t['title'] ?? '',
                  duration: t['duration'],
                  position: t['position'].toString()[0],
                ),
              )
              .toList();
          _loadingTracklist = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loadingTracklist = false);
      }
    }
  }

  Future<void> _startListening(BuildContext context) async {
    final timerService = ListeningTimerService();

    await timerService.startListening(
      albumId: widget.album.id.toString(),
      albumTitle: widget.album.basicInfo.title,
      artistName: widget.album.basicInfo.artists.map((a) => a.name).join(', '),
      coverImage:
          widget.album.basicInfo.coverImage ?? widget.album.basicInfo.thumb,
    );

    await AnalyticsService().logListeningStarted(
      albumId: widget.album.id.toString(),
      albumTitle: widget.album.basicInfo.title,
      artistName: widget.album.basicInfo.artists.map((a) => a.name).join(', '),
    );

    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Começou a ouvir "${widget.album.basicInfo.title}"'),
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
        timerService.currentSession?.albumId == widget.album.id.toString();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: 'album_${widget.album.id}',
                child: Image.network(
                  widget.album.basicInfo.coverImage ??
                      widget.album.basicInfo.thumb ??
                      '',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
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
                        widget.album.basicInfo.title,
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
                        widget.album.basicInfo.artists
                            .map((a) => a.name)
                            .join(', '),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 8),

                    if (widget.album.basicInfo.year > 0)
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Opacity(opacity: value, child: child);
                        },
                        child: Text(
                          widget.album.basicInfo.year.toString(),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                        ),
                      ),

                    const SizedBox(height: 16),

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

                    const SizedBox(height: 24),

                    if (_loadingTracklist)
                      const CircularProgressIndicator()
                    else if (_tracklist != null && _tracklist!.isNotEmpty)
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Opacity(opacity: value, child: child);
                        },
                        child: Column(
                          children: [
                            for (var track in _tracklist!)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      track.position ?? '',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        track.title,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                        softWrap: true,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      track.duration ?? '',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
