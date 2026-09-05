import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../widgets/exercise_animation.dart';
import 'completion_screen.dart';

enum _Phase { getReady, work, rest }

/// The whole workout happens on this one screen: animation, cues, timer and
/// controls. Nothing to navigate, nothing to decide.
class WorkoutScreen extends StatefulWidget {
  final DayWorkout workout;
  const WorkoutScreen({super.key, required this.workout});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late final List<WorkoutItem> _seq = widget.workout.sequence;

  int _index = 0;
  int _remaining = 5;
  int _elapsed = 0;
  int _blocksDone = 0;
  bool _paused = false;
  bool _showGo = false;
  _Phase _phase = _Phase.getReady;
  Timer? _timer;

  AppState get _state => AppScope.of(context);

  @override
  void initState() {
    super.initState();
    WakelockFallback.keepAwake();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ------------------------------------------------------------------ engine

  void _tick() {
    if (_paused) return;
    setState(() {
      _elapsed++;
      if (_remaining > 0) _remaining--;
      if (_remaining > 0 && _remaining <= 3) _cue(soft: true);
      if (_remaining == 0) _advance();
    });
  }

  void _advance() {
    if (_phase == _Phase.getReady) {
      _startWork();
      return;
    }
    if (_phase == _Phase.work) {
      if (_index >= _seq.length - 1) {
        _finish();
        return;
      }
      final rest = _seq[_index].rest;
      if (rest > 0) {
        _phase = _Phase.rest;
        _remaining = rest;
        _cue();
      } else {
        _index++;
        _startWork();
      }
      return;
    }
    // Rest finished.
    _index++;
    _startWork();
  }

  void _startWork() {
    _phase = _Phase.work;
    _remaining = _seq[_index].workSeconds;
    _showGo = true;
    _cue();
    _syncBlockProgress();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _showGo = false);
    });
  }

  void _syncBlockProgress() {
    final block = widget.workout.blockIndexForItem(_index);
    if (block > _blocksDone) {
      _blocksDone = block;
      _state.setBlockProgress(widget.workout.day, block);
    }
  }

  void _cue({bool soft = false}) {
    if (_state.sound) SystemSound.play(SystemSoundType.click);
    if (_state.haptics) {
      soft ? HapticFeedback.selectionClick() : HapticFeedback.mediumImpact();
    }
  }

  void _skip() {
    setState(() {
      if (_phase == _Phase.getReady) {
        _startWork();
      } else if (_phase == _Phase.rest) {
        _index++;
        _startWork();
      } else if (_index >= _seq.length - 1) {
        _finish();
      } else {
        _index++;
        _startWork();
      }
    });
  }

  void _previous() {
    setState(() {
      if (_index > 0) _index--;
      _startWork();
    });
  }

  void _finish() {
    _timer?.cancel();
    WakelockFallback.release();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => CompletionScreen(
          workout: widget.workout,
          seconds: _elapsed,
          exercises: _seq.length,
        ),
      ),
    );
  }

  Future<void> _confirmExit() async {
    setState(() => _paused = true);
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave this workout?'),
        content: const Text(
          'Your finished sections are saved, so you can pick up where you '
          'stopped.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep going'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(90, 42)),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    if (leave == true && mounted) {
      _timer?.cancel();
      WakelockFallback.release();
      Navigator.of(context).pop();
    } else if (mounted) {
      setState(() => _paused = false);
    }
  }

  String _clock(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  // ------------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final item = _seq[_index];
    final block = widget.workout.blocks[widget.workout.blockIndexForItem(_index)];
    final resting = _phase == _Phase.rest;
    final ready = _phase == _Phase.getReady;
    final next = _index < _seq.length - 1 ? _seq[_index + 1] : null;

    final accent = resting ? t.colorScheme.tertiary : t.colorScheme.primary;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // ------------------------------------------------------- header
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _confirmExit,
                      icon: const Icon(Icons.close_rounded),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(block.name,
                              style: t.textTheme.titleMedium),
                          Text(
                            'Day ${widget.workout.day} \u00b7 ${_index + 1} of ${_seq.length} \u00b7 ${_clock(_elapsed)}',
                            style: TextStyle(
                                fontSize: 12.5, color: t.colorScheme.outline),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: (_index + 1) / _seq.length,
                minHeight: 4,
                backgroundColor: t.colorScheme.primary.withValues(alpha: .12),
              ),

              // ---------------------------------------------------- animation
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: ExerciseAnimation(
                    anim: item.exercise.anim,
                    color: accent,
                    playing: !_paused && !resting,
                  ),
                ),
              ),

              // ------------------------------------------------------ details
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        ready
                            ? 'GET READY'
                            : (resting ? 'REST' : item.exercise.name.toUpperCase()),
                        textAlign: TextAlign.center,
                        style: t.textTheme.titleLarge?.copyWith(
                          fontSize: 20,
                          letterSpacing: .6,
                          color: accent,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _showGo
                            ? 'GO!'
                            : (ready || resting
                                ? _clock(_remaining)
                                : (item.timed ? '$_remaining' : item.prescription)),
                        style: TextStyle(
                          fontSize: _showGo ? 58 : 68,
                          fontWeight: FontWeight.w800,
                          height: 1.05,
                          letterSpacing: -2,
                        ),
                      ),
                      if (!ready && !resting)
                        Text(
                          item.timed ? 'SECONDS' : 'REPETITIONS',
                          style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 1.6,
                              color: t.colorScheme.outline),
                        ),
                      const SizedBox(height: 12),
                      if (resting && next != null)
                        Text(
                          'Next: ${next.exercise.name} \u00b7 ${next.prescription}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                        )
                      else if (!ready)
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            for (final c in item.exercise.cues)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 11, vertical: 6),
                                decoration: BoxDecoration(
                                  color: accent.withValues(alpha: .10),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(c,
                                    style: const TextStyle(
                                        fontSize: 12.5, fontWeight: FontWeight.w600)),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              // ----------------------------------------------------- controls
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton.filledTonal(
                      iconSize: 26,
                      onPressed: _previous,
                      icon: const Icon(Icons.skip_previous_rounded),
                    ),
                    SizedBox(
                      width: 84,
                      height: 84,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () => setState(() => _paused = !_paused),
                        child: Icon(
                          _paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                          size: 40,
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      iconSize: 26,
                      onPressed: _skip,
                      icon: const Icon(Icons.skip_next_rounded),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Keeps the screen awake during a session without adding a plugin
/// dependency \u2014 falls back silently if the platform channel is unavailable.
class WakelockFallback {
  static const _channel = MethodChannel('workout/wakelock');

  static Future<void> keepAwake() async {
    try {
      await _channel.invokeMethod('enable');
    } catch (_) {
      // Not implemented on this platform; the workout still runs normally.
    }
  }

  static Future<void> release() async {
    try {
      await _channel.invokeMethod('disable');
    } catch (_) {
      // Ignored.
    }
  }
}
