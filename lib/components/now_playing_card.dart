import 'package:flutter/material.dart';
import 'package:maleva_spins/models/listening_session.dart';
import 'package:maleva_spins/services/listening_timer_service.dart';

class NowPlayingCard extends StatelessWidget {
  final ListeningSession session;
  final VoidCallback onStop;

  const NowPlayingCard({
    super.key,
    required this.session,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final timerService = ListeningTimerService();
    final scheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: timerService,
      builder: (context, _) {
        final elapsed = session.elapsedTime;
        final total = timerService.totalListeningTime + elapsed;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Capa do álbum
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    session.coverImage ?? '',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        color: scheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.album,
                          color: scheme.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),

                // Informações
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: scheme.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tocando agora',
                            style: TextStyle(
                              fontSize: 12,
                              color: scheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.albumTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: scheme.onPrimaryContainer,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        session.artistName,
                        style: TextStyle(
                          fontSize: 14,
                          color: scheme.onPrimaryContainer.withValues(
                            alpha: 0.8,
                          ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: scheme.onPrimaryContainer.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            timerService.formatDuration(elapsed),
                            style: TextStyle(
                              fontSize: 13,
                              color: scheme.onPrimaryContainer.withValues(
                                alpha: 0.7,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.timer,
                            size: 14,
                            color: scheme.onPrimaryContainer.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Total: ${timerService.formatDuration(total)}',
                            style: TextStyle(
                              fontSize: 13,
                              color: scheme.onPrimaryContainer.withValues(
                                alpha: 0.7,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Botão de parar
                IconButton(
                  onPressed: onStop,
                  icon: Icon(
                    Icons.stop_circle,
                    color: scheme.onPrimaryContainer,
                    size: 32,
                  ),
                  tooltip: 'Parar',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
