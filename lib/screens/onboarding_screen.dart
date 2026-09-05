import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/notifications.dart';
import '../state/app_state.dart';
import 'home_shell.dart';
import 'safety_screen.dart';

/// Four short questions and a safety notice. Nothing else stands between the
/// user and Day 1.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  FitnessLevel _level = FitnessLevel.beginner;
  DurationTier _tier = DurationTier.quick;
  WorkoutTime _time = WorkoutTime.morning;
  bool _reminder = false;
  TimeOfDay _reminderAt = const TimeOfDay(hour: 7, minute: 0);

  static const _titles = [
    'Welcome',
    'Your fitness level',
    'How long do you want to train?',
    'When do you usually train?',
    'Before you start',
  ];

  Future<void> _finish() async {
    final state = AppScope.of(context);
    if (_reminder) {
      await NotificationService.instance.requestPermission();
    }
    await state.updateSettings(
      level: _level,
      tier: _tier,
      preferredTime: _time,
      reminderEnabled: _reminder,
      reminderHour: _reminderAt.hour,
      reminderMinute: _reminderAt.minute,
      onboarded: true,
      safetyAccepted: true,
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: List.generate(
                  5,
                  (i) => Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: i <= _step
                            ? t.colorScheme.primary
                            : t.colorScheme.primary.withValues(alpha: .16),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(_titles[_step], style: t.textTheme.headlineMedium),
              const SizedBox(height: 18),
              Expanded(child: SingleChildScrollView(child: _body())),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  if (_step == 4) {
                    _finish();
                  } else {
                    setState(() => _step++);
                  }
                },
                child: Text(_step == 4 ? 'I understand \u2014 start Day 1' : 'Continue'),
              ),
              if (_step > 0)
                TextButton(
                  onPressed: () => setState(() => _step--),
                  child: const Text('Back'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    switch (_step) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'One workout a day, for thirty days.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 14),
            const Text(
              'You will never have to decide what to train. Open the app, press '
              'start, follow the timer. Everything works without an internet '
              'connection and there is no account to create.\n\n'
              'Four quick questions and you are set.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            for (final l in FitnessLevel.values)
              _Choice(
                title: l.label,
                subtitle: l.blurb,
                selected: _level == l,
                onTap: () => setState(() => _level = l),
              ),
          ],
        );
      case 2:
        return Column(
          children: [
            for (final d in DurationTier.values)
              _Choice(
                title: '${d.label} \u2014 about ${d.minutes} minutes',
                subtitle: switch (d) {
                  DurationTier.quick => 'The essential session: warm-up, main circuit, core, cooldown.',
                  DurationTier.standard => 'Adds a second circuit and a fuller cooldown.',
                  DurationTier.extended => 'Adds accessory strength and a conditioning block.',
                  DurationTier.complete => 'A full session with extra strength, conditioning and mobility.',
                },
                selected: _tier == d,
                onTap: () => setState(() => _tier = d),
              ),
            const SizedBox(height: 8),
            const Text(
              'You can change this at any time in Settings.',
              style: TextStyle(fontSize: 13),
            ),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final w in WorkoutTime.values)
              _Choice(
                title: w.label,
                selected: _time == w,
                onTap: () => setState(() {
                  _time = w;
                  _reminderAt = TimeOfDay(hour: w.defaultHour, minute: 0);
                }),
              ),
            const SizedBox(height: 20),
            Text('Would you like a daily reminder?',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _reminder = true),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _reminder
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: .12)
                          : null,
                    ),
                    child: const Text('Yes, set reminder'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _reminder = false),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: !_reminder
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: .12)
                          : null,
                    ),
                    child: const Text('Maybe later'),
                  ),
                ),
              ],
            ),
            if (_reminder) ...[
              const SizedBox(height: 14),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.alarm),
                title: Text('Remind me at ${_reminderAt.format(context)}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final picked = await showTimePicker(
                      context: context, initialTime: _reminderAt);
                  if (picked != null) setState(() => _reminderAt = picked);
                },
              ),
              const Text(
                'Each reminder carries that day\u2019s message and is generated on '
                'your device.',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ],
        );
      default:
        return const SafetyNotice();
    }
  }
}

class _Choice extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _Choice({
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? t.colorScheme.primary
                  : t.colorScheme.outlineVariant,
              width: selected ? 2 : 1,
            ),
            color: selected
                ? t.colorScheme.primary.withValues(alpha: .08)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: t.textTheme.titleMedium),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(subtitle!, style: const TextStyle(fontSize: 13.5, height: 1.35)),
                    ],
                  ],
                ),
              ),
              Icon(
                selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected ? t.colorScheme.primary : t.colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
