import 'package:flutter/material.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/exercise_animation.dart';
import 'workout_screen.dart';

/// Preview of any unlocked day: its task blocks, every exercise, and a way in
/// to the full exercise detail.
Future<void> showDayDetail(BuildContext context, int day) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: .85,
      maxChildSize: .95,
      builder: (context, controller) => _DayDetail(day: day, controller: controller),
    ),
  );
}

class _DayDetail extends StatelessWidget {
  final int day;
  final ScrollController controller;
  const _DayDetail({required this.day, required this.controller});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final t = Theme.of(context);
    final w = state.workoutFor(day);
    final done = state.isCompleted(day);

    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 34),
      children: [
        Row(
          children: [
            Pill('Day $day', icon: Icons.today),
            const SizedBox(width: 8),
            Pill(w.phase),
            if (done) ...[
              const SizedBox(width: 8),
              const Pill('Completed', icon: Icons.check, color: AppColors.success),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Text(w.title, style: t.textTheme.headlineMedium?.copyWith(fontSize: 25)),
        const SizedBox(height: 6),
        Text(w.focus, style: TextStyle(color: t.colorScheme.outline, height: 1.4)),
        const SizedBox(height: 12),
        Text(
          '${w.minutes} min \u00b7 ${w.tier.label} \u00b7 ${w.level.label} \u00b7 ${w.exerciseCount} sets',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        for (final b in w.blocks) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(b.name, style: t.textTheme.titleMedium),
              Text(b.subtitle,
                  style: TextStyle(color: t.colorScheme.outline, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 6),
          for (final i in b.items)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: SizedBox(
                width: 44,
                height: 44,
                child: ExerciseAnimation(
                  anim: i.exercise.anim,
                  color: t.colorScheme.primary,
                  strokeWidth: 3,
                ),
              ),
              title: Text(i.exercise.name),
              subtitle: Text('${i.prescription} \u00b7 rest ${i.rest}s'),
              trailing: const Icon(Icons.info_outline, size: 20),
              onTap: () => _showExercise(context, i.exercise),
            ),
          const SizedBox(height: 14),
        ],
        const SizedBox(height: 6),
        if (state.isUnlocked(day) && !done)
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => WorkoutScreen(workout: w)),
              );
            },
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text('Start Day $day'),
          ),
      ],
    );
  }
}

void _showExercise(BuildContext context, Exercise e) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      final t = Theme.of(context);
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: .8,
        builder: (context, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 34),
          children: [
            SizedBox(
              height: 160,
              child: ExerciseAnimation(anim: e.anim, color: t.colorScheme.primary),
            ),
            const SizedBox(height: 8),
            Text(e.name, style: t.textTheme.headlineMedium?.copyWith(fontSize: 24)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Pill(e.category),
                Pill(e.target),
                Pill('Equipment: ${e.equipment}'),
                Pill('Difficulty ${e.difficulty}/3'),
                Pill(e.timed ? '${e.seconds}s work' : '${e.reps} reps'),
                Pill('Rest ${e.rest}s'),
              ],
            ),
            const SizedBox(height: 18),
            _Section('Starting position', e.startPosition),
            _Section('Movement', e.movement),
            _Section('Breathing', e.breathing),
            _Section('Common mistake', e.mistake),
            _Section('Easier', e.easier),
            _Section('Standard', e.standard),
            _Section('Harder', e.harder),
          ],
        ),
      );
    },
  );
}

class _Section extends StatelessWidget {
  final String title;
  final String body;
  const _Section(this.title, this.body);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                letterSpacing: .4,
                color: Theme.of(context).colorScheme.primary,
              )),
          const SizedBox(height: 4),
          Text(body, style: const TextStyle(fontSize: 15, height: 1.45)),
        ],
      ),
    );
  }
}
