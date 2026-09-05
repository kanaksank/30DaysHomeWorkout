import 'package:flutter/material.dart';

import '../data/day_blueprints.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme.dart';
import 'workout_screen.dart';

/// Today, and only today. Two taps from here to a running workout.
class HomeTab extends StatelessWidget {
  final VoidCallback onSeeProgress;
  const HomeTab({super.key, required this.onSeeProgress});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final t = Theme.of(context);
    final w = state.todayWorkout;
    final doneToday = state.isCompleted(state.currentDay);
    final tasksDone = state.blockProgress[state.currentDay] ?? 0;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 40),
        children: [
          Text('${state.greeting} \ud83d\udc4b',
              style: t.textTheme.titleMedium?.copyWith(color: t.colorScheme.outline)),
          const SizedBox(height: 4),
          Text(
            doneToday && state.currentDay >= 30
                ? 'Challenge complete'
                : (doneToday
                    ? 'Day ${state.currentDay} is done'
                    : 'Day ${state.currentDay} is ready'),
            style: t.textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),

          if (state.hasMissedDays) _MissedCard(state: state),

          _TodayCard(workout: w, state: state),

          const SizedBox(height: 18),
          Text('Today\u2019s tasks', style: t.textTheme.titleMedium),
          const SizedBox(height: 8),
          ...w.blocks.asMap().entries.map((e) {
            final done = doneToday || e.key < tasksDone;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Icon(
                done ? Icons.check_circle : Icons.circle_outlined,
                color: done ? AppColors.success : t.colorScheme.outline,
              ),
              title: Text(e.value.name),
              trailing: Text(e.value.subtitle,
                  style: TextStyle(color: t.colorScheme.outline, fontSize: 13)),
            );
          }),
          const SizedBox(height: 4),
          Text(
            '${doneToday ? w.blocks.length : tasksDone} / ${w.blocks.length} tasks complete',
            style: TextStyle(color: t.colorScheme.outline, fontSize: 13),
          ),

          const SizedBox(height: 22),
          if (!doneToday)
            FilledButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => WorkoutScreen(workout: w)),
              ),
              icon: const Icon(Icons.play_arrow_rounded, size: 26),
              label: Text(tasksDone > 0 ? 'Resume Day ${w.day}' : 'Start workout'),
            )
          else ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Day ${w.day} complete \ud83c\udf89',
                      style: t.textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text(state.currentDay >= 30 && state.challengeFinished
                      ? 'You finished all thirty days.'
                      : 'Tomorrow: Day ${(w.day + 1).clamp(1, 30)} \u2014 ${Program.day(w.day + 1).title}'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onSeeProgress, child: const Text('View progress')),
          ],

          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: t.colorScheme.primary.withValues(alpha: .07),
            ),
            child: Row(
              children: [
                const Text('\u201c', style: TextStyle(fontSize: 30, height: 1)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(w.quote,
                      style: const TextStyle(fontSize: 15, height: 1.45)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  final DayWorkout workout;
  final AppState state;
  const _TodayCard({required this.workout, required this.state});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Pill('Day ${workout.day} of 30', icon: Icons.today),
                const SizedBox(width: 8),
                Pill(workout.level.label, icon: Icons.trending_up),
                if (workout.challengeLevel > 1) ...[
                  const SizedBox(width: 8),
                  Pill('Level ${workout.challengeLevel}'),
                ],
              ],
            ),
            const SizedBox(height: 14),
            Text(workout.title, style: t.textTheme.headlineMedium?.copyWith(fontSize: 26)),
            const SizedBox(height: 6),
            Text(workout.focus, style: TextStyle(color: t.colorScheme.outline, height: 1.4)),
            const SizedBox(height: 16),
            Row(
              children: [
                _Stat(icon: Icons.schedule, label: '${workout.minutes} min'),
                _Stat(icon: Icons.fitness_center, label: '${workout.exerciseCount} sets'),
                _Stat(
                  icon: Icons.local_fire_department_outlined,
                  label: '~${workout.calorieEstimate} kcal',
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Text('Difficulty', style: TextStyle(color: t.colorScheme.outline, fontSize: 13)),
                const SizedBox(width: 8),
                ...List.generate(
                  5,
                  (i) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i < workout.difficulty
                            ? t.colorScheme.primary
                            : t.colorScheme.primary.withValues(alpha: .18),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Text('\ud83d\udd25 ${state.streak}',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Calorie figures are a rough estimate only.',
              style: TextStyle(fontSize: 11.5, color: t.colorScheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Stat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 17, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 5),
          Flexible(
            child: Text(label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
          ),
        ],
      ),
    );
  }
}

class _MissedCard extends StatelessWidget {
  final AppState state;
  const _MissedCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColors.accent.withValues(alpha: .10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('That\u2019s okay. Your challenge is still here.',
              style: t.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'Nothing has been reset. Pick up where you left off, or move the '
            'counter forward to match today.',
            style: TextStyle(color: t.colorScheme.outline, height: 1.4, fontSize: 13.5),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(44)),
                  onPressed: state.keepCurrentDay,
                  child: Text('Continue Day ${state.currentDay}'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
                  onPressed: state.moveToToday,
                  child: const Text('Move to today'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
