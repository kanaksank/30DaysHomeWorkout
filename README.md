# 30 Days Home Workout — Offline Flutter App

An offline-first Flutter application that guides an adult through a sequential
30-day bodyweight home workout challenge. One clear workout per day, an
in-app timer, hand-drawn (code-drawn) exercise animations, daily task lists,
streaks and progress tracking — all working with **no internet, no account,
no login**.

## Highlights

- **Sequential challenge** — Day 1 unlocks Day 2, and so on to the Day 30 Final Challenge.
- **Four duration tiers** — Quick (~30 min), Standard (~45), Extended (~60), Complete (~90).
  Longer sessions add *new* blocks (accessory, conditioning, tempo strength, extended
  mobility) before ever adding another round, so a 90-minute session is not a repeated
  30-minute one.
- **Three fitness levels** — Beginner / Intermediate / Advanced swap the *exercise
  variation* and the *work-to-rest structure*, not just the rep count.
- **Offline animations** — every exercise is animated with a lightweight custom
  Flutter `CustomPainter` skeleton (start position → movement → return). No video,
  no network assets, a few KB of code instead of megabytes of media.
- **Built-in workout timer** — 3-2-1-GO countdown, auto-advance, pause/resume,
  skip, previous/next, rest screens, optional sounds and haptics.
- **Daily task list** — every day is broken into checkable blocks (Warm-up,
  Circuit 1, Circuit 2, Core, Cooldown …) with `x / y tasks complete`.
- **Progress** — 30-day calendar grid, streak, best streak, total time, milestones.
- **Kind missed-day handling** — nothing resets; you choose *Continue Day N* or *Move to today*.
- **Local reminders** — a daily notification carrying that day's original message.
- **Challenge Level 2+** — restarting generates a harder progression, history is kept.

## Getting started

```bash
flutter pub get
flutter run
```

Requires Flutter 3.19+ / Dart 3.3+. Android and iOS.

## Project layout

```
lib/
  main.dart                     app entry, theme wiring
  theme.dart                    colours, typography, shared UI bits
  models/models.dart            Exercise, WorkoutItem/Block, DayWorkout, enums
  data/exercise_library.dart    ~60 original bodyweight exercises (full detail)
  data/day_blueprints.dart      the 30-day program + 30 original daily messages
  data/plan_builder.dart        builds a concrete workout from day × level × duration
  services/storage.dart         SharedPreferences persistence (offline)
  services/notifications.dart   local daily reminders
  state/app_state.dart          single ChangeNotifier app state
  widgets/exercise_animation.dart   code-drawn offline exercise animations
  screens/                      onboarding, safety, home, challenge, progress,
                                settings, workout player, completion, finale
docs/PROGRAM_DESIGN.md          methodology + sources
```

## Safety

This app provides general fitness guidance and is **not medical advice**. It is not a
medical device and makes no weight-loss, muscle-gain or treatment claims. A safety
screen is shown before the challenge begins. See `docs/PROGRAM_DESIGN.md`.

## Originality

All exercise descriptions, cues, program structure, daily messages, UI and animations
in this repository were written for this project. Public-domain public-health guidance
(WHO physical activity recommendations, ACSM position stands) informed the *methodology*
only; no third-party text, artwork or app content is reproduced.
