import 'package:flutter/material.dart';

import '../data/day_blueprints.dart';
import '../state/app_state.dart';
import '../theme.dart';

/// Streak, totals and a simple completed/not-completed calendar strip.
class ProgressTab extends StatelessWidget {
  const ProgressTab({super.key});

  String _hours(int s) => '${s ~/ 3600}h ${(s % 3600) ~/ 60}m';

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final t = Theme.of(context);
    final pct = state.completedCount / 30;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 40),
        children: [
          Text('Progress', style: t.textTheme.headlineMedium),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('30-Day Challenge', style: t.textTheme.titleMedium),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 14,
                      backgroundColor: t.colorScheme.primary.withValues(alpha: .12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('${state.completedCount} / 30 days',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _StatCard(
                icon: Icons.local_fire_department,
                label: 'Current streak',
                value: '${state.streak} days',
                color: AppColors.accent,
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: Icons.emoji_events_outlined,
                label: 'Best streak',
                value: '${state.bestStreak} days',
                color: AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatCard(
                icon: Icons.schedule,
                label: 'Total workout time',
                value: _hours(state.totalSeconds),
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: Icons.fitness_center,
                label: 'Completed workouts',
                value: '${state.completedCount}',
              ),
            ],
          ),
          const SizedBox(height: 26),
          Text('Calendar', style: t.textTheme.titleMedium),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 30,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, i) {
              final day = i + 1;
              final done = state.isCompleted(day);
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done
                      ? AppColors.success
                      : t.colorScheme.primary.withValues(alpha: .10),
                ),
                child: Center(
                  child: Icon(
                    done ? Icons.check : Icons.circle,
                    size: done ? 15 : 6,
                    color: done ? Colors.white : t.colorScheme.outline,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 26),
          Text('Milestones', style: t.textTheme.titleMedium),
          const SizedBox(height: 10),
          ...Program.milestones.entries.map((m) {
            final reached = state.completedCount >= m.key || state.isCompleted(m.key);
            return ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Icon(
                reached ? Icons.workspace_premium : Icons.workspace_premium_outlined,
                color: reached ? AppColors.accent : t.colorScheme.outline,
              ),
              title: Text(m.value),
              subtitle: Text('Day ${m.key}'),
            );
          }),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = color ?? t.colorScheme.primary;
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: c),
              const SizedBox(height: 10),
              Text(value, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(label, style: TextStyle(fontSize: 12, color: t.colorScheme.outline)),
            ],
          ),
        ),
      ),
    );
  }
}
