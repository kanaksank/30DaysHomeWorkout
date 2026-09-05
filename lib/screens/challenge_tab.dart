import 'package:flutter/material.dart';

import '../data/day_blueprints.dart';
import '../state/app_state.dart';
import '../theme.dart';
import 'day_detail_sheet.dart';

/// The 30-day calendar. Completed days are obvious at a glance, locked days
/// are quiet, today is highlighted.
class ChallengeTab extends StatelessWidget {
  const ChallengeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final t = Theme.of(context);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 40),
        children: [
          Text(
            state.challengeLevel > 1
                ? '30-Day Challenge \u2014 Level ${state.challengeLevel}'
                : '30-Day Challenge',
            style: t.textTheme.headlineMedium,
          ),
          const SizedBox(height: 6),
          Text('${state.completedCount} of 30 days complete',
              style: TextStyle(color: t.colorScheme.outline)),
          const SizedBox(height: 18),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 30,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, i) {
              final day = i + 1;
              final done = state.isCompleted(day);
              final unlocked = state.isUnlocked(day);
              final isToday = day == state.currentDay && !done;

              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: unlocked
                    ? () => showDayDetail(context, day)
                    : () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Day $day unlocks after Day ${day - 1}.'),
                          ),
                        ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: done
                        ? AppColors.success.withValues(alpha: .18)
                        : (isToday
                            ? t.colorScheme.primary.withValues(alpha: .14)
                            : t.colorScheme.surfaceContainerHighest.withValues(alpha: .4)),
                    border: isToday
                        ? Border.all(color: t.colorScheme.primary, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: done
                        ? const Icon(Icons.check_rounded, color: AppColors.success)
                        : Text(
                            '$day',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: unlocked
                                  ? t.colorScheme.onSurface
                                  : t.colorScheme.outline.withValues(alpha: .55),
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 26),
          Text('Phases', style: t.textTheme.titleMedium),
          const SizedBox(height: 10),
          ...const [
            ['Days 1\u20135', 'Foundation \u2014 movement quality and breathing'],
            ['Days 6\u201310', 'Foundation + endurance \u2014 longer intervals'],
            ['Days 11\u201315', 'Strength & conditioning \u2014 multi-exercise circuits'],
            ['Days 16\u201320', 'Intermediate progression \u2014 harder variations'],
            ['Days 21\u201325', 'Performance \u2014 denser circuits, shorter rests'],
            ['Days 26\u201329', 'Final preparation \u2014 everything combined'],
            ['Day 30', 'The finish challenge'],
          ].map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 92,
                    child: Text(p[0], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                  ),
                  Expanded(
                    child: Text(p[1],
                        style: TextStyle(color: t.colorScheme.outline, fontSize: 13.5, height: 1.35)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Weekly shape: full body, lower body, upper body and core, cardio and '
            'mobility, full-body strength, conditioning, then a genuine recovery '
            'day. Recovery days give you a real task \u2014 mobility and breathing \u2014 '
            'rather than a hard session in disguise.',
            style: TextStyle(color: t.colorScheme.outline, fontSize: 13, height: 1.45),
          ),
          const SizedBox(height: 8),
          Text('Next up: ${Program.day(state.currentDay).title}',
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
