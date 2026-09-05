import 'package:flutter/material.dart';

/// Plain-language safety notice. Shown during onboarding and reachable from
/// Settings at any time.
class SafetyNotice extends StatelessWidget {
  const SafetyNotice({super.key});

  static const _points = [
    'This app provides general fitness guidance and is not medical advice.',
    'Start at a level appropriate for your current fitness. There is no prize for choosing the hardest option today.',
    'Stop if you experience unusual pain, dizziness, chest pain, severe shortness of breath, or if you feel unwell.',
    'Consult a qualified healthcare professional before beginning a new exercise programme if you have health concerns or have been advised to restrict physical activity.',
    'Warm up before, cool down after, and use the easier variation whenever a movement does not feel right.',
    'Progress gradually. This programme is built to increase slowly rather than push you to maximum intensity.',
  ];

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final p in _points)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_rounded, size: 20, color: t.colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(p, style: const TextStyle(fontSize: 15, height: 1.45)),
                ),
              ],
            ),
          ),
        const SizedBox(height: 6),
        Text(
          'This app is not a medical device and makes no claims about weight '
          'loss, muscle gain or the treatment of any condition.',
          style: TextStyle(fontSize: 13, color: t.colorScheme.outline, height: 1.4),
        ),
      ],
    );
  }
}

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safety & privacy')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 40),
        children: const [
          SafetyNotice(),
          SizedBox(height: 26),
          Text('Privacy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          SizedBox(height: 10),
          Text(
            'Everything this app stores \u2014 your settings, completed days, streak '
            'and workout history \u2014 stays on your device. There is no account, no '
            'sign-in and no analytics call. The app never needs an internet '
            'connection to work.',
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }
}
