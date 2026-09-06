import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/notifications.dart';
import '../state/app_state.dart';
import 'safety_screen.dart';

/// Duration, level, reminder, sound/haptics, theme and privacy \u2014 nothing more.
class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final t = Theme.of(context);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 40),
        children: [
          Text('Settings', style: t.textTheme.headlineMedium),
          const SizedBox(height: 18),

          _SectionLabel('Workout duration'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final d in DurationTier.values)
                ChoiceChip(
                  label: Text('${d.label} (${d.minutes}m)'),
                  selected: state.tier == d,
                  onSelected: (_) => state.updateSettings(tier: d),
                ),
            ],
          ),

          const SizedBox(height: 22),
          _SectionLabel('Fitness level'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final l in FitnessLevel.values)
                ChoiceChip(
                  label: Text(l.label),
                  selected: state.level == l,
                  onSelected: (_) => state.updateSettings(level: l),
                ),
            ],
          ),

          const SizedBox(height: 22),
          _SectionLabel('Reminder'),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Daily reminder'),
            subtitle: const Text('A local notification with that day\u2019s message.'),
            value: state.reminderEnabled,
            onChanged: (v) async {
              if (v) await NotificationService.instance.requestPermission();
              state.updateSettings(reminderEnabled: v);
            },
          ),
          if (state.reminderEnabled)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.alarm),
              title: Text(
                'Remind me at ${TimeOfDay(hour: state.reminderHour, minute: state.reminderMinute).format(context)}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: state.reminderHour, minute: state.reminderMinute),
                );
                if (picked != null) {
                  state.updateSettings(reminderHour: picked.hour, reminderMinute: picked.minute);
                }
              },
            ),

          const SizedBox(height: 22),
          _SectionLabel('Sound & haptics'),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Sound cues'),
            value: state.sound,
            onChanged: (v) => state.updateSettings(sound: v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Vibration'),
            value: state.haptics,
            onChanged: (v) => state.updateSettings(haptics: v),
          ),

          const SizedBox(height: 22),
          _SectionLabel('Appearance'),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('System'),
                selected: state.themeMode == ThemeMode.system,
                onSelected: (_) => state.updateSettings(themeMode: ThemeMode.system),
              ),
              ChoiceChip(
                label: const Text('Light'),
                selected: state.themeMode == ThemeMode.light,
                onSelected: (_) => state.updateSettings(themeMode: ThemeMode.light),
              ),
              ChoiceChip(
                label: const Text('Dark'),
                selected: state.themeMode == ThemeMode.dark,
                onSelected: (_) => state.updateSettings(themeMode: ThemeMode.dark),
              ),
            ],
          ),

          const SizedBox(height: 22),
          _SectionLabel('Privacy'),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Safety & privacy notice'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SafetyScreen()),
            ),
          ),

          const SizedBox(height: 22),
          _SectionLabel('Reset'),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset everything?'),
                  content: const Text(
                    'This clears your progress, streak and settings on this device. '
                    'This cannot be undone.',
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel')),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              );
              if (ok == true) await state.resetEverything();
            },
            icon: const Icon(Icons.restart_alt),
            label: const Text('Reset challenge & settings'),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          letterSpacing: .4,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }
}
