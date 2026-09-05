import 'package:flutter/material.dart';

import 'challenge_tab.dart';
import 'home_tab.dart';
import 'progress_tab.dart';
import 'settings_tab.dart';

/// Four tabs, nothing more.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeTab(onSeeProgress: () => setState(() => _index = 2)),
          const ChallengeTab(),
          const ProgressTab(),
          const SettingsTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view), label: 'Challenge'),
          NavigationDestination(
              icon: Icon(Icons.insights_outlined), selectedIcon: Icon(Icons.insights), label: 'Progress'),
          NavigationDestination(
              icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
