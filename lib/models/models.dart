import 'package:flutter/foundation.dart';

/// ---------------------------------------------------------------------------
/// Enums
/// ---------------------------------------------------------------------------

enum FitnessLevel { beginner, intermediate, advanced }

extension FitnessLevelX on FitnessLevel {
  String get label => switch (this) {
        FitnessLevel.beginner => 'Beginner',
        FitnessLevel.intermediate => 'Intermediate',
        FitnessLevel.advanced => 'Advanced',
      };

  String get blurb => switch (this) {
        FitnessLevel.beginner =>
          'Lower impact, simpler variations, longer rests.',
        FitnessLevel.intermediate =>
          'Standard bodyweight work, tighter rests, more volume.',
        FitnessLevel.advanced =>
          'Harder variations, dense circuits, short rests.',
      };
}

enum DurationTier { quick, standard, extended, complete }

extension DurationTierX on DurationTier {
  String get label => switch (this) {
        DurationTier.quick => 'Quick',
        DurationTier.standard => 'Standard',
        DurationTier.extended => 'Extended',
        DurationTier.complete => 'Complete',
      };

  /// Target session length in minutes.
  int get minutes => switch (this) {
        DurationTier.quick => 30,
        DurationTier.standard => 45,
        DurationTier.extended => 60,
        DurationTier.complete => 90,
      };
}

enum WorkoutTime { morning, afternoon, evening, custom }

extension WorkoutTimeX on WorkoutTime {
  String get label => switch (this) {
        WorkoutTime.morning => 'Morning',
        WorkoutTime.afternoon => 'Afternoon',
        WorkoutTime.evening => 'Evening',
        WorkoutTime.custom => 'Custom time',
      };

  int get defaultHour => switch (this) {
        WorkoutTime.morning => 7,
        WorkoutTime.afternoon => 13,
        WorkoutTime.evening => 18,
        WorkoutTime.custom => 18,
      };
}

/// Block kinds used to label the daily task list.
enum BlockKind { warmup, circuit, strength, cardio, core, mobility, cooldown }

extension BlockKindX on BlockKind {
  String get label => switch (this) {
        BlockKind.warmup => 'Warm-up',
        BlockKind.circuit => 'Circuit',
        BlockKind.strength => 'Strength',
        BlockKind.cardio => 'Conditioning',
        BlockKind.core => 'Core',
        BlockKind.mobility => 'Mobility',
        BlockKind.cooldown => 'Cooldown',
      };
}

/// ---------------------------------------------------------------------------
/// Exercise
/// ---------------------------------------------------------------------------

@immutable
class Exercise {
  final String id;
  final String name;
  final String category;
  final String target;
  final String equipment;

  /// 1 = easy, 2 = moderate, 3 = demanding.
  final int difficulty;

  final String startPosition;
  final String movement;
  final String breathing;
  final String mistake;

  final String easier;
  final String standard;
  final String harder;

  /// Two or three very short on-screen cues shown next to the animation.
  final List<String> cues;

  /// Animation archetype key, resolved by [ExerciseAnimation].
  final String anim;

  final bool timed;
  final int seconds;
  final int reps;
  final int rest;

  /// Optional links to a genuinely different movement, used by the level system
  /// so that Beginner and Advanced do not simply share one exercise at
  /// different rep counts.
  final String? regressionId;
  final String? progressionId;

  /// Rough intensity factor used only for a friendly calorie estimate.
  final double intensity;

  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.target,
    required this.difficulty,
    required this.startPosition,
    required this.movement,
    required this.breathing,
    required this.mistake,
    required this.easier,
    required this.standard,
    required this.harder,
    required this.cues,
    required this.anim,
    this.equipment = 'None',
    this.timed = true,
    this.seconds = 40,
    this.reps = 12,
    this.rest = 20,
    this.regressionId,
    this.progressionId,
    this.intensity = 1.0,
  });
}

/// ---------------------------------------------------------------------------
/// A built workout
/// ---------------------------------------------------------------------------

@immutable
class WorkoutItem {
  final Exercise exercise;
  final bool timed;
  final int seconds;
  final int reps;
  final int rest;

  const WorkoutItem({
    required this.exercise,
    required this.timed,
    required this.seconds,
    required this.reps,
    required this.rest,
  });

  /// Repetition work is estimated at ~2.6 s per controlled repetition so that
  /// session length stays predictable.
  int get workSeconds => timed ? seconds : (reps * 2.6).round();

  int get totalSeconds => workSeconds + rest;

  String get prescription => timed ? '$seconds SEC' : '$reps REPS';
}

@immutable
class WorkoutBlock {
  final String name;
  final BlockKind kind;
  final int rounds;
  final List<WorkoutItem> items;

  /// Extra rest taken once at the end of each round.
  final int roundRest;

  const WorkoutBlock({
    required this.name,
    required this.kind,
    required this.rounds,
    required this.items,
    this.roundRest = 0,
  });

  int get totalSeconds =>
      rounds *
      (items.fold<int>(0, (a, b) => a + b.totalSeconds) + roundRest);

  int get exerciseCount => rounds * items.length;

  /// Flattened play order, round by round.
  List<WorkoutItem> get sequence => [
        for (var r = 0; r < rounds; r++) ...items,
      ];

  String get subtitle {
    final mins = (totalSeconds / 60).round();
    if (rounds > 1) return '$rounds rounds \u00b7 ${mins} min';
    return '$mins min';
  }
}

@immutable
class DayWorkout {
  final int day;
  final String title;
  final String focus;
  final String phase;
  final String quote;
  final String completionMessage;
  final bool recoveryDay;
  final FitnessLevel level;
  final DurationTier tier;
  final int challengeLevel;
  final List<WorkoutBlock> blocks;

  const DayWorkout({
    required this.day,
    required this.title,
    required this.focus,
    required this.phase,
    required this.quote,
    required this.completionMessage,
    required this.recoveryDay,
    required this.level,
    required this.tier,
    required this.challengeLevel,
    required this.blocks,
  });

  int get totalSeconds => blocks.fold<int>(0, (a, b) => a + b.totalSeconds);

  int get minutes => (totalSeconds / 60).round();

  int get exerciseCount => blocks.fold<int>(0, (a, b) => a + b.exerciseCount);

  /// 1 (easy) .. 5 (hard) — shown as dots on the home card.
  int get difficulty {
    if (recoveryDay) return 1;
    final base = (day / 7).ceil().clamp(1, 5);
    final lift = switch (level) {
      FitnessLevel.beginner => 0,
      FitnessLevel.intermediate => 0,
      FitnessLevel.advanced => 1,
    };
    return (base + lift + (challengeLevel - 1)).clamp(1, 5);
  }

  /// Deliberately labelled as an estimate in the UI. Not a medical figure.
  int get calorieEstimate {
    final intensitySum = blocks.fold<double>(
      0,
      (a, b) =>
          a +
          b.rounds *
              b.items.fold<double>(
                  0, (x, i) => x + i.exercise.intensity * i.workSeconds),
    );
    return (intensitySum / 60 * 6.5).round();
  }

  List<String> get taskNames => [for (final b in blocks) b.name];

  /// The play list used by the workout player.
  List<WorkoutItem> get sequence => [for (final b in blocks) ...b.sequence];

  /// Index of the block that owns the item at [i] in [sequence].
  int blockIndexForItem(int i) {
    var seen = 0;
    for (var b = 0; b < blocks.length; b++) {
      final n = blocks[b].sequence.length;
      if (i < seen + n) return b;
      seen += n;
    }
    return blocks.length - 1;
  }
}

/// ---------------------------------------------------------------------------
/// Persistence records
/// ---------------------------------------------------------------------------

@immutable
class CompletedDay {
  final int day;
  final int challengeLevel;
  final DateTime date;
  final int seconds;
  final int exercises;

  const CompletedDay({
    required this.day,
    required this.challengeLevel,
    required this.date,
    required this.seconds,
    required this.exercises,
  });

  Map<String, dynamic> toJson() => {
        'day': day,
        'cl': challengeLevel,
        'date': date.toIso8601String(),
        'sec': seconds,
        'ex': exercises,
      };

  factory CompletedDay.fromJson(Map<String, dynamic> j) => CompletedDay(
        day: j['day'] as int,
        challengeLevel: (j['cl'] ?? 1) as int,
        date: DateTime.parse(j['date'] as String),
        seconds: (j['sec'] ?? 0) as int,
        exercises: (j['ex'] ?? 0) as int,
      );
}
