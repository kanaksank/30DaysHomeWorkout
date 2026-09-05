import '../models/models.dart';
import 'day_blueprints.dart';
import 'exercise_library.dart';

/// Turns a [DayBlueprint] into a concrete [DayWorkout] for a given fitness
/// level, duration tier and challenge level.
///
/// Design rules encoded here:
///  * A longer session first adds *new* sections (accessory strength,
///    conditioning, extended mobility) and only then adds rounds, so the
///    90-minute version is not the 30-minute version repeated.
///  * Levels swap the *variation* (via regression / progression links) and
///    change the work-to-rest structure, instead of multiplying repetitions.
///  * Rounds are then fitted to the target duration, within sane bounds.
class PlanBuilder {
  const PlanBuilder._();

  static DayWorkout build({
    required int day,
    required FitnessLevel level,
    required DurationTier tier,
    int challengeLevel = 1,
  }) {
    final bp = Program.day(day);
    final t = _Tuning(day: day, level: level, challengeLevel: challengeLevel, recovery: bp.recovery);

    final drafts = <_Draft>[];

    // ---------------------------------------------------------------- warm-up
    final warmCount = switch (tier) {
      DurationTier.quick => 3,
      DurationTier.standard => 4,
      _ => 5,
    };
    drafts.add(_Draft(
      name: 'Warm-up',
      kind: BlockKind.warmup,
      ids: bp.warmup.take(warmCount).toList(),
      rounds: 1,
      fixed: true,
      work: 35,
      rest: 8,
    ));

    // ---------------------------------------------------------------- circuits
    final aCount = tier == DurationTier.quick ? 4 : (tier == DurationTier.standard ? 4 : 5);
    drafts.add(_Draft(
      name: bp.recovery ? 'Mobility Flow 1' : (bp.isFinal ? 'Full-Body Finish Circuit' : 'Circuit 1'),
      kind: bp.recovery ? BlockKind.mobility : BlockKind.circuit,
      ids: bp.circuitA.take(aCount).toList(),
      rounds: t.rounds,
      roundRest: t.roundRest,
    ));

    if (tier != DurationTier.quick || bp.isFinal) {
      final bCount = tier == DurationTier.standard ? 3 : 4;
      drafts.add(_Draft(
        name: bp.recovery ? 'Mobility Flow 2' : (bp.isFinal ? 'Power Circuit' : 'Circuit 2'),
        kind: bp.recovery ? BlockKind.mobility : BlockKind.circuit,
        ids: bp.circuitB.take(bCount).toList(),
        rounds: bp.isFinal ? t.rounds - 1 : t.rounds,
        roundRest: t.roundRest,
      ));
    }

    // --------------------------------------------------------- accessory work
    if (tier == DurationTier.extended || tier == DurationTier.complete || bp.isFinal) {
      drafts.add(_Draft(
        name: bp.recovery ? 'Gentle Strength' : 'Strength Block',
        kind: BlockKind.strength,
        ids: bp.strength,
        rounds: bp.recovery ? 2 : (tier == DurationTier.complete ? 3 : 2),
        tempo: true,
      ));
    }

    // ------------------------------------------------------------ conditioning
    if (tier == DurationTier.extended || tier == DurationTier.complete || bp.isFinal) {
      drafts.add(_Draft(
        name: bp.recovery ? 'Easy Movement' : 'Conditioning',
        kind: BlockKind.cardio,
        ids: bp.conditioning,
        rounds: bp.recovery ? 1 : 2,
        roundRest: t.roundRest,
      ));
    }

    // --------------------------------------------------------------------- core
    drafts.add(_Draft(
      name: bp.recovery ? 'Gentle Core' : 'Core',
      kind: BlockKind.core,
      ids: bp.core.take(tier == DurationTier.quick ? 2 : 3).toList(),
      rounds: tier == DurationTier.quick ? 2 : 2,
      roundRest: t.roundRest,
    ));

    // ---------------------------------------------------------------- cooldown
    final coolCount = switch (tier) {
      DurationTier.quick => 2,
      DurationTier.standard => 3,
      DurationTier.extended => 4,
      DurationTier.complete => 5,
    };
    drafts.add(_Draft(
      name: 'Cooldown',
      kind: BlockKind.cooldown,
      ids: bp.cooldown.take(coolCount).toList(),
      rounds: 1,
      fixed: true,
      work: 40,
      rest: 6,
    ));

    // ------------------------------------------------------------ fit duration
    final target = tier.minutes * 60;
    final scalable = drafts.where((d) => !d.fixed).toList();
    var guard = 0;
    while (_estimate(drafts, t) < target - 150 && guard < 24) {
      final d = scalable[guard % scalable.length];
      if (d.rounds < (bp.recovery ? 3 : 6)) d.rounds++;
      guard++;
    }
    guard = 0;
    while (_estimate(drafts, t) > target + 180 && guard < 24) {
      final d = scalable[guard % scalable.length];
      if (d.rounds > 1) d.rounds--;
      guard++;
    }

    final blocks = [for (final d in drafts) d.toBlock(t)];

    return DayWorkout(
      day: bp.day,
      title: bp.title,
      focus: bp.focus,
      phase: bp.phase,
      quote: Program.quoteFor(bp.day, challengeLevel),
      completionMessage: Program.completionFor(bp.day),
      recoveryDay: bp.recovery,
      level: level,
      tier: tier,
      challengeLevel: challengeLevel,
      blocks: blocks,
    );
  }

  static int _estimate(List<_Draft> drafts, _Tuning t) =>
      drafts.fold<int>(0, (a, d) => a + d.toBlock(t).totalSeconds);
}

/// Level / phase driven numbers.
class _Tuning {
  final FitnessLevel level;
  final int challengeLevel;
  final bool recovery;
  final int day;

  const _Tuning({
    required this.day,
    required this.level,
    required this.challengeLevel,
    required this.recovery,
  });

  /// Base rounds by training phase.
  int get rounds {
    if (recovery) return 1;
    final base = day <= 5
        ? 2
        : day <= 10
            ? 3
            : day <= 20
                ? 3
                : 4;
    return (base + (challengeLevel - 1)).clamp(2, 5);
  }

  int get roundRest => recovery ? 5 : (level == FitnessLevel.beginner ? 40 : (level == FitnessLevel.advanced ? 20 : 30));

  /// Work interval adjustment in seconds.
  int get workDelta => switch (level) {
        FitnessLevel.beginner => -8,
        FitnessLevel.intermediate => 0,
        FitnessLevel.advanced => 6,
      } + (challengeLevel - 1) * 4;

  /// Rest interval adjustment in seconds.
  int get restDelta => switch (level) {
        FitnessLevel.beginner => 10,
        FitnessLevel.intermediate => 0,
        FitnessLevel.advanced => -6,
      } - (challengeLevel - 1) * 2;

  /// Later phases tighten the rest a little further.
  int get phaseRestDelta {
    if (recovery) return 0;
    if (day <= 5) return 4;
    if (day <= 10) return 0;
    if (day <= 20) return -2;
    return -4;
  }

  double get repFactor => switch (level) {
        FitnessLevel.beginner => 0.75,
        FitnessLevel.intermediate => 1.0,
        FitnessLevel.advanced => 1.2,
      };

  /// Swap to an easier or harder movement where the library offers one.
  Exercise resolve(Exercise e) {
    var out = e;
    if (level == FitnessLevel.beginner && e.regressionId != null) {
      out = ExerciseLibrary.byId(e.regressionId!);
    } else if (level == FitnessLevel.advanced && e.progressionId != null) {
      out = ExerciseLibrary.byId(e.progressionId!);
    }
    if (challengeLevel > 1 && out.progressionId != null && level != FitnessLevel.beginner) {
      out = ExerciseLibrary.byId(out.progressionId!);
    }
    return out;
  }
}

/// Mutable block used while fitting the session to its target length.
class _Draft {
  final String name;
  final BlockKind kind;
  final List<String> ids;
  final bool fixed;
  final bool tempo;
  final int? work;
  final int? rest;
  final int roundRest;
  int rounds;

  _Draft({
    required this.name,
    required this.kind,
    required this.ids,
    required this.rounds,
    this.fixed = false,
    this.tempo = false,
    this.work,
    this.rest,
    this.roundRest = 0,
  });

  WorkoutBlock toBlock(_Tuning t) {
    final items = <WorkoutItem>[];
    for (final id in ids) {
      final raw = ExerciseLibrary.byId(id);
      final e = fixed ? raw : t.resolve(raw);

      if (fixed) {
        items.add(WorkoutItem(
          exercise: e,
          timed: true,
          seconds: work ?? e.seconds,
          reps: e.reps,
          rest: rest ?? e.rest,
        ));
        continue;
      }

      final restSec =
          (e.rest + t.restDelta + t.phaseRestDelta).clamp(8, 45).toInt();

      if (e.timed) {
        final sec = (e.seconds + t.workDelta + (tempo ? 5 : 0)).clamp(20, 75).toInt();
        items.add(WorkoutItem(
            exercise: e, timed: true, seconds: sec, reps: e.reps, rest: restSec));
      } else {
        final reps = (e.reps * t.repFactor).round().clamp(5, 30).toInt();
        items.add(WorkoutItem(
            exercise: e,
            timed: false,
            seconds: e.seconds,
            reps: tempo ? (reps * 0.8).round().clamp(5, 30).toInt() : reps,
            rest: tempo ? (restSec + 5) : restSec));
      }
    }

    return WorkoutBlock(
      name: name,
      kind: kind,
      rounds: rounds,
      items: items,
      roundRest: fixed ? 0 : roundRest,
    );
  }
}
