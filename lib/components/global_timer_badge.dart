import 'package:flutter/material.dart';
import 'package:maleva_spins/services/listening_timer_service.dart';

class GlobalTimerBadge extends StatelessWidget {
  const GlobalTimerBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final timerService = ListeningTimerService();
    final scheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: timerService,
      builder: (context, _) {
        final total = timerService.totalTimeWithCurrent;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                scheme.tertiaryContainer,
                scheme.tertiaryContainer.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.headphones,
                color: scheme.onTertiaryContainer,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Tempo total ouvido: ',
                style: TextStyle(
                  color: scheme.onTertiaryContainer.withValues(alpha: 0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                timerService.formatDuration(total),
                style: TextStyle(
                  color: scheme.onTertiaryContainer,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
