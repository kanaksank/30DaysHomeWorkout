# Program design notes

This document explains the methodology behind the 30-day program and lists the
authoritative guidance that informed it. No wording, illustrations, exercise
descriptions or program structure were copied from any existing app.

## Guiding principles

1. **Progressive overload, applied gently.** Across 30 days, difficulty rises
   through several independent levers rather than one blunt one: session
   length, number of rounds, work-to-rest ratio, exercise variation, and
   circuit density. Day 30 is harder than Day 1 in several ways at once, which
   is closer to how real programming works than simply "more reps every day."

2. **Level changes the movement, not just the numbers.** Each exercise in the
   library may declare a `regressionId` (an easier but related movement) and a
   `progressionId` (a harder one). Beginner mode substitutes regressions,
   Advanced mode substitutes progressions, and a second challenge cycle pushes
   intermediate/advanced users one progression further still. This avoids the
   trap of simply multiplying a beginner's reps by two or three.

3. **Duration changes the session shape, not just its length.** A 30-minute
   day contains a warm-up, one circuit, a short core block and a cooldown. The
   45-minute version adds a second circuit. The 60-minute version adds a
   dedicated strength block and a conditioning block. The 90-minute version
   extends all of the above and adds more cooldown/mobility time. Rounds are
   only added once every relevant section already exists, so longer sessions
   are structurally richer, not just repetitive.

4. **A real weekly rhythm.** Every week follows a full body / lower body /
   upper body + core / cardio + mobility / full body strength / conditioning /
   recovery shape (adapted per phase), so no single muscle group or energy
   system is hammered on consecutive days.

5. **Recovery is programmed, not improvised.** Days 7, 14, 21 and 28 are true
   mobility/recovery days with their own task list (mobility flow, gentle
   strength maintenance, breathing) rather than a lighter version of a hard
   workout.

6. **Kind adherence design.** Missing a day never resets the 30-day counter.
   The user is offered a plain choice: continue the missed day, or move the
   counter to match today. This mirrors common behaviour-change guidance that
   adherence, not perfection, predicts long-term outcomes.

## Public-health guidance consulted (methodology only)

- World Health Organization, *WHO guidelines on physical activity and
  sedentary behaviour* \u2014 the recommendation that adults accumulate 150\u2013300
  minutes of moderate aerobic activity per week (or an equivalent amount of
  vigorous activity) and perform muscle-strengthening activity for the major
  muscle groups on 2 or more days per week. This shaped the overall weekly mix
  of cardio, strength, core and mobility work, not any specific wording or
  workout structure.
- American College of Sports Medicine (ACSM) resistance-training position
  stands \u2014 general principles of progressive overload and the standing that
  bodyweight and home-based resistance training are legitimate, effective
  training modalities for general fitness, which supported building the whole
  program around equipment-free bodyweight movements.

No text, exercise descriptions, illustrations or workout plans from any
third-party source, app, book or website were reproduced. All program
structure, exercise cues, motivational messages and UI copy in this repository
were written specifically for this project.

## Safety

The app is not a medical device, does not diagnose or treat any condition, and
makes no promises about weight loss, muscle gain or other health outcomes. A
safety notice (see `lib/screens/safety_screen.dart`) is shown before a user's
first workout and is reachable at any time from Settings.
