import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../data/day_blueprints.dart';

/// Local-only daily reminders. Every notification is generated from the
/// bundled challenge data, so reminders keep working with no connection.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
    _ready = true;
  }

  Future<bool> requestPermission() async {
    await init();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    final a = await android?.requestNotificationsPermission();
    final i = await ios?.requestPermissions(alert: true, sound: true, badge: true);
    return (a ?? i ?? true) == true;
  }

  Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }

  /// Schedules the next [count] daily reminders, each carrying the message for
  /// the day the user is expected to be on.
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required int startDay,
    required int challengeLevel,
    int count = 10,
  }) async {
    await init();
    await _plugin.cancelAll();

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_challenge',
        'Daily challenge reminder',
        channelDescription: 'A daily nudge to complete your workout.',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
    );

    final now = tz.TZDateTime.now(tz.local);
    for (var i = 0; i < count; i++) {
      final day = startDay + i;
      if (day > 30) break;

      var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute)
          .add(Duration(days: i));
      if (when.isBefore(now)) when = when.add(const Duration(days: 1));

      final title = day == 30
          ? 'Day 30 \u2014 the final challenge \ud83c\udfc1'
          : (day == 15
              ? 'Day 15 \u2014 halfway point \ud83d\udcaa'
              : 'Day $day is ready \ud83d\udd25');

      await _plugin.zonedSchedule(
        day,
        title,
        Program.quoteFor(day, challengeLevel),
        when,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }
}
