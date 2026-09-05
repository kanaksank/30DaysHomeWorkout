import 'package:flutter/material.dart';

import '../data/plan_builder.dart';
import '../models/models.dart';
import '../services/notifications.dart';
import '../services/storage.dart';

/// Single source of truth for the whole app. Everything here is persisted
/// locally and rehydrated on launch.
class AppState extends ChangeNotifier {
  bool onboarded = false;
  bool safetyAccepted = false;

  FitnessLevel level = FitnessLevel.beginner;
  DurationTier tier = DurationTier.quick;
  WorkoutTime preferredTime = WorkoutTime.morning;

  bool reminderEnabled = false;
  int reminderHour = 7;
  int reminderMinute = 0;

  bool sound = true;
  bool haptics = true;
  ThemeMode themeMode = ThemeMode.system;

  int currentDay = 1;
  int challengeLevel = 1;

  /// Completed days of the *current* challenge.
  final Map<int, CompletedDay> completed = {};

  /// Every completed day ever, including previous challenges.
  final List<CompletedDay> history = [];

  /// day -> number of task blocks finished (so a partly done day is remembered).
  final Map<int, int> blockProgress = {};

  int bestStreak = 0;

  /// Set once the user dismisses the missed-day prompt for this session.
  bool missedPromptHandled = false;

  // ------------------------------------------------------------------ derived

  DayWorkout workoutFor(int day) => PlanBuilder.build(
        day: day,
        level: level,
        tier: tier,
        challengeLevel: challengeLevel,
      );

  DayWorkout get todayWorkout => workoutFor(currentDay);

  bool isCompleted(int day) => completed.containsKey(day);

  bool isUnlocked(int day) => day <= currentDay;

  bool get challengeFinished => completed.length >= 30;

  int get completedCount => completed.length;

  int get totalSeconds =>
      history.fold<int>(0, (a, b) => a + b.seconds);

  int get totalExercises =>
      history.fold<int>(0, (a, b) => a + b.exercises);

  /// Consecutive calendar days with a completed workout, counting back from
  /// today or yesterday.
  int get streak {
    if (history.isEmpty) return 0;
    final days = history
        .map((c) => DateTime(c.date.year, c.date.month, c.date.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));
    final today = DateTime.now();
    final t0 = DateTime(today.year, today.month, today.day);
    if (days.first != t0 && days.first != t0.subtract(const Duration(days: 1))) {
      return 0;
    }
    var count = 1;
    for (var i = 1; i < days.length; i++) {
      if (days[i - 1].difference(days[i]).inDays == 1) {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  /// How many calendar days have slipped since the last completed workout.
  int get daysSinceLastWorkout {
    if (history.isEmpty) return 0;
    final last = history
        .map((c) => DateTime(c.date.year, c.date.month, c.date.day))
        .reduce((a, b) => a.isAfter(b) ? a : b);
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day).difference(last).inDays;
  }

  bool get hasMissedDays =>
      !missedPromptHandled && daysSinceLastWorkout >= 2 && !isCompleted(currentDay);

  bool get completedToday {
    if (history.isEmpty) return false;
    final now = DateTime.now();
    return history.any((c) =>
        c.date.year == now.year &&
        c.date.month == now.month &&
        c.date.day == now.day);
  }

  String get greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 18) return 'Good afternoon';
    return 'Good evening';
  }

  // ------------------------------------------------------------------ mutators

  Future<void> completeDay({
    required int day,
    required int seconds,
    required int exercises,
  }) async {
    final record = CompletedDay(
      day: day,
      challengeLevel: challengeLevel,
      date: DateTime.now(),
      seconds: seconds,
      exercises: exercises,
    );
    completed[day] = record;
    history.add(record);
    blockProgress.remove(day);
    if (day == currentDay && currentDay < 30) currentDay = day + 1;
    if (streak > bestStreak) bestStreak = streak;
    missedPromptHandled = false;
    await _persist();
    await _rescheduleReminders();
    notifyListeners();
  }

  Future<void> setBlockProgress(int day, int blocksDone) async {
    blockProgress[day] = blocksDone;
    await _persist();
    notifyListeners();
  }

  /// Kind handling of a gap: jump the day counter forward to match the
  /// calendar without wiping anything that was already earned.
  Future<void> moveToToday() async {
    final skip = daysSinceLastWorkout - 1;
    currentDay = (currentDay + (skip > 0 ? skip : 0)).clamp(1, 30);
    missedPromptHandled = true;
    await _persist();
    notifyListeners();
  }

  Future<void> keepCurrentDay() async {
    missedPromptHandled = true;
    notifyListeners();
  }

  /// Starts the next challenge with a harder progression. History is kept.
  Future<void> startNextChallenge() async {
    challengeLevel += 1;
    currentDay = 1;
    completed.clear();
    blockProgress.clear();
    await _persist();
    await _rescheduleReminders();
    notifyListeners();
  }

  Future<void> updateSettings({
    FitnessLevel? level,
    DurationTier? tier,
    WorkoutTime? preferredTime,
    bool? reminderEnabled,
    int? reminderHour,
    int? reminderMinute,
    bool? sound,
    bool? haptics,
    ThemeMode? themeMode,
    bool? onboarded,
    bool? safetyAccepted,
  }) async {
    if (level != null) this.level = level;
    if (tier != null) this.tier = tier;
    if (preferredTime != null) this.preferredTime = preferredTime;
    if (reminderEnabled != null) this.reminderEnabled = reminderEnabled;
    if (reminderHour != null) this.reminderHour = reminderHour;
    if (reminderMinute != null) this.reminderMinute = reminderMinute;
    if (sound != null) this.sound = sound;
    if (haptics != null) this.haptics = haptics;
    if (themeMode != null) this.themeMode = themeMode;
    if (onboarded != null) this.onboarded = onboarded;
    if (safetyAccepted != null) this.safetyAccepted = safetyAccepted;
    await _persist();
    await _rescheduleReminders();
    notifyListeners();
  }

  Future<void> resetEverything() async {
    await Storage.clear();
    onboarded = false;
    safetyAccepted = false;
    currentDay = 1;
    challengeLevel = 1;
    completed.clear();
    history.clear();
    blockProgress.clear();
    bestStreak = 0;
    await NotificationService.instance.cancelAll();
    notifyListeners();
  }

  // --------------------------------------------------------------- persistence

  Future<void> _rescheduleReminders() async {
    if (!reminderEnabled) {
      await NotificationService.instance.cancelAll();
      return;
    }
    await NotificationService.instance.scheduleDaily(
      hour: reminderHour,
      minute: reminderMinute,
      startDay: currentDay,
      challengeLevel: challengeLevel,
    );
  }

  Future<void> _persist() async {
    await Storage.write({
      'onboarded': onboarded,
      'safety': safetyAccepted,
      'level': level.index,
      'tier': tier.index,
      'time': preferredTime.index,
      'reminder': reminderEnabled,
      'rh': reminderHour,
      'rm': reminderMinute,
      'sound': sound,
      'haptics': haptics,
      'theme': themeMode.index,
      'day': currentDay,
      'cl': challengeLevel,
      'best': bestStreak,
      'completed': completed.values.map((c) => c.toJson()).toList(),
      'history': history.map((c) => c.toJson()).toList(),
      'blocks': blockProgress.map((k, v) => MapEntry(k.toString(), v)),
    });
  }

  Future<void> load() async {
    final d = await Storage.read();
    if (d.isEmpty) return;
    onboarded = d['onboarded'] as bool? ?? false;
    safetyAccepted = d['safety'] as bool? ?? false;
    level = FitnessLevel.values[(d['level'] as int? ?? 0).clamp(0, 2)];
    tier = DurationTier.values[(d['tier'] as int? ?? 0).clamp(0, 3)];
    preferredTime = WorkoutTime.values[(d['time'] as int? ?? 0).clamp(0, 3)];
    reminderEnabled = d['reminder'] as bool? ?? false;
    reminderHour = d['rh'] as int? ?? 7;
    reminderMinute = d['rm'] as int? ?? 0;
    sound = d['sound'] as bool? ?? true;
    haptics = d['haptics'] as bool? ?? true;
    themeMode = ThemeMode.values[(d['theme'] as int? ?? 0).clamp(0, 2)];
    currentDay = (d['day'] as int? ?? 1).clamp(1, 30);
    challengeLevel = d['cl'] as int? ?? 1;
    bestStreak = d['best'] as int? ?? 0;

    completed.clear();
    for (final j in (d['completed'] as List? ?? const [])) {
      final c = CompletedDay.fromJson(Map<String, dynamic>.from(j as Map));
      completed[c.day] = c;
    }
    history
      ..clear()
      ..addAll([
        for (final j in (d['history'] as List? ?? const []))
          CompletedDay.fromJson(Map<String, dynamic>.from(j as Map))
      ]);
    blockProgress.clear();
    (d['blocks'] as Map? ?? {}).forEach((k, v) {
      final key = int.tryParse('$k');
      if (key != null) blockProgress[key] = v as int;
    });
  }
}

/// Simple inherited access so screens can read the state without a package.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope missing from the widget tree');
    return scope!.notifier!;
  }
}
