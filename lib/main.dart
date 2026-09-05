import 'package:flutter/material.dart';

import 'screens/home_shell.dart';
import 'screens/onboarding_screen.dart';
import 'services/notifications.dart';
import 'state/app_state.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState();
  await state.load();
  await NotificationService.instance.init();
  runApp(ChallengeApp(state: state));
}

class ChallengeApp extends StatelessWidget {
  final AppState state;
  const ChallengeApp({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: AnimatedBuilder(
        animation: state,
        builder: (context, _) => MaterialApp(
          title: '30-Day Home Workout',
          debugShowCheckedModeBanner: false,
          theme: buildTheme(Brightness.light),
          darkTheme: buildTheme(Brightness.dark),
          themeMode: state.themeMode,
          home: state.onboarded ? const HomeShell() : const OnboardingScreen(),
        ),
      ),
    );
  }
}
