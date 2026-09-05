import 'package:flutter/material.dart';

import '../data/day_blueprints.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme.dart';
import 'home_shell.dart';

/// Shown the moment a session ends. Day 30 gets its own, bigger version.
class CompletionScreen extends StatefulWidget {
  final DayWorkout workout;
  final int seconds;
  final int exercises;

  const CompletionScreen({
    super.key,
    required this.workout,
    required this.seconds,
    required this.exercises,
  });

  @override
  State<CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen> {
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_saved) return;
      _saved = true;
      await AppScope.of(context).completeDay(
        day: widget.workout.day,
        seconds: widget.seconds,
        exercises: widget.exercises,
      );
    });
  }

  String _clock(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  String _hours(int s) => '${s ~/ 3600}h ${(s % 3600) ~/ 60}m';

  void _done() => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeShell()),
        (route) => false,
      );

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final t = Theme.of(context);
    final isFinal = widget.workout.day == 30;
    final milestone = Program.milestones[widget.workout.day];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
          children: [
            Text(
              isFinal ? '30 DAYS COMPLETE \ud83c\udf89' : '\ud83c\udf89 WORKOUT COMPLETE',
              style: t.textTheme.headlineMedium?.copyWith(fontSize: isFinal ? 30 : 22),
            ),
            const SizedBox(height: 8),
            Text(
              isFinal
                  ? 'You finished the whole challenge.'
                  : 'Day ${widget.workout.day} complete',
              style: t.textTheme.titleLarge,
            ),
            const SizedBox(height: 24),

            _StatRow(label: 'Duration', value: _clock(widget.seconds)),
            _StatRow(label: 'Exercises', value: '${widget.exercises}'),
            _StatRow(label: 'Workout streak', value: '${state.streak} days \ud83d\udd25'),
            if (isFinal) ...[
              _StatRow(label: 'Days completed', value: '${state.completedCount} / 30'),
              _StatRow(label: 'Total workout time', value: _hours(state.totalSeconds)),
              _StatRow(label: 'Total exercises', value: '${state.totalExercises}'),
              _StatRow(label: 'Best streak', value: '${state.bestStreak} days'),
            ],

            const SizedBox(height: 22),
            if (milestone != null)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: AppColors.accent.withValues(alpha: .12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.workspace_premium_outlined, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Badge unlocked', style: t.textTheme.titleMedium),
                          Text(milestone),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: t.colorScheme.primary.withValues(alpha: .08),
              ),
              child: Text(
                widget.workout.completionMessage,
                style: const TextStyle(fontSize: 15.5, height: 1.45),
              ),
            ),

            if (!isFinal) ...[
              const SizedBox(height: 18),
              Text(
                'Tomorrow: Day ${(widget.workout.day + 1).clamp(1, 30)} \u2014 '
                '${Program.day(widget.workout.day + 1).title}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],

            const SizedBox(height: 28),
            if (isFinal)
              FilledButton(
                onPressed: () async {
                  await state.startNextChallenge();
                  if (context.mounted) _done();
                },
                child: Text('Start another 30-Day Challenge \u2014 Level ${state.challengeLevel + 1}'),
              ),
            if (isFinal) const SizedBox(height: 10),
            FilledButton(onPressed: _done, child: const Text('Done')),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _done,
              child: const Text('View progress'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: Theme.of(context).colorScheme.outline)),
          Text(value,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
