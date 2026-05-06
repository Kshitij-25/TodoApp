import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/task_model.dart';

class NotificationService {
  factory NotificationService() => _instance;
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  
  Function(String taskId)? onReschedule;
  Function()? onRollover;

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // 1. Initialize Timezone
    tz.initializeTimeZones();

    // 2. Request Permission
    NotificationSettings settings = await _fcm.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else {
      log('User declined or has not accepted permission');
    }

    // 3. Initialize Local Notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    // Define Actions
    const AndroidNotificationAction rescheduleAction =
        AndroidNotificationAction(
      'reschedule',
      'Reschedule',
      showsUserInterface: true,
    );

    const AndroidNotificationAction rolloverAction = AndroidNotificationAction(
      'rollover',
      'Roll over',
      showsUserInterface: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleNotificationAction,
    );

    // 3. Handle Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('Got a message whilst in the foreground!');

      // Fetch current settings (optional: or pass them in)
      // For simplicity, we can show notifications if they are enabled in Firestore
      // but usually the backend should only send if enabled.
      // If we want device-side filtering:
      await _showLocalNotification(message);
    });

    // 4. Get FCM Token
    String? token = await _fcm.getToken();
    log('FCM Token: $token');
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'todo_reminders',
      'Todo Reminders',
      channelDescription: 'Notifications for task reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.notification.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformDetails,
      payload: message.data.toString(),
    );
  }

  // --- Advanced Notification Logic ---

  /// Schedules reminders for all tasks, grouping those due in the same hour
  Future<void> scheduleAllTaskReminders(List<TaskModel> tasks) async {
    // 1. Group tasks by their due hour
    final Map<String, List<TaskModel>> hourlyGroups = {};
    for (var task in tasks) {
      if (task.isCompleted) continue;
      final hourKey = DateFormat('yyyy-MM-dd HH').format(task.dueDate);
      hourlyGroups.putIfAbsent(hourKey, () => []).add(task);
    }

    final timeFormat = DateFormat.jm();

    for (var entry in hourlyGroups.entries) {
      final hourTasks = entry.value;
      final firstTask = hourTasks.first;

      if (hourTasks.length > 1) {
        // Grouped notification
        final dueSoonTime = firstTask.dueDate.subtract(const Duration(minutes: 30));
        if (dueSoonTime.isAfter(DateTime.now())) {
          await _scheduleNotification(
            id: entry.key.hashCode,
            title: '${hourTasks.length} tasks due soon',
            body: '${hourTasks.length} tasks are due by ${timeFormat.format(firstTask.dueDate.add(const Duration(minutes: 60 - 0)))}', // Roughly "by X PM"
            scheduledTime: dueSoonTime,
            priority: Priority.high,
            type: 'due_soon_grouped',
          );
        }
      } else {
        // Single task notification
        await scheduleTaskReminders(firstTask);
      }
    }
  }

  /// Schedules reminders for a specific task
  Future<void> scheduleTaskReminders(TaskModel task) async {
    if (task.isCompleted) return;

    final timeFormat = DateFormat.jm(); // e.g. 3:00 PM

    // 1. Due Soon Reminder
    final dueSoonTime = task.dueDate.subtract(const Duration(minutes: 30));
    if (dueSoonTime.isAfter(DateTime.now())) {
      await _scheduleNotification(
        id: task.id.hashCode,
        title: '${task.title} in 30 min',
        body: 'Due at ${timeFormat.format(task.dueDate)} • ${task.priority} priority',
        scheduledTime: dueSoonTime,
        priority: Priority.high,
        type: 'due_soon',
      );
    }

    // 2. Overdue Alert
    final overdueTime = task.dueDate.add(const Duration(minutes: 15));
    if (overdueTime.isAfter(DateTime.now())) {
      await _scheduleNotification(
        id: task.id.hashCode + 1,
        title: 'Past due: ${task.title}',
        body: 'Was due at ${timeFormat.format(task.dueDate)} • Tap to reschedule',
        scheduledTime: overdueTime,
        priority: Priority.max,
        type: 'overdue',
        actions: ['reschedule'],
      );
    }
  }

  /// Cancels all notifications for a specific task
  Future<void> cancelTaskReminders(String taskId) async {
    await _localNotifications.cancel(taskId.hashCode);
    await _localNotifications.cancel(taskId.hashCode + 1);
  }

  /// Schedules daily morning briefing with busiest day detection
  Future<void> scheduleMorningBriefing(List<TaskModel> allTasks) async {
    final todayTasks = allTasks.where((t) => 
      t.dueDate.year == DateTime.now().year && 
      t.dueDate.month == DateTime.now().month && 
      t.dueDate.day == DateTime.now().day).toList();
    
    if (todayTasks.isEmpty) return;

    final overdueCount = allTasks.where((t) => !t.isCompleted && t.dueDate.isBefore(DateTime.now())).length;
    
    // Detect busiest day of the week
    final Map<String, int> dailyCounts = {};
    for (var task in allTasks) {
      if (task.dueDate.isAfter(DateTime.now())) {
        final day = DateFormat('EEEE').format(task.dueDate);
        dailyCounts[day] = (dailyCounts[day] ?? 0) + 1;
      }
    }
    
    String busiestDay = "";
    int maxCount = 0;
    dailyCounts.forEach((day, count) {
      if (count > maxCount) {
        maxCount = count;
        busiestDay = day;
      }
    });

    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, 8);
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await _scheduleNotification(
      id: 1001,
      title: 'Morning briefing',
      body: '${todayTasks.length} tasks today • $overdueCount overdue. ${busiestDay.isNotEmpty ? "Your busiest day is $busiestDay." : ""} Start strong.',
      scheduledTime: scheduledTime,
      priority: Priority.defaultPriority,
      type: 'briefing',
    );
  }

  /// Schedules evening wrap-up (opt-in)
  Future<void> scheduleEveningWrapUp(int completed, int total) async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool('evening_wrapup_enabled') ?? false;
    if (!isEnabled) return;

    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, 20); // 8 PM
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await _scheduleNotification(
      id: 1002,
      title: 'Evening wrap-up',
      body:
          'You completed $completed of $total tasks today. Roll over incomplete tasks?',
      scheduledTime: scheduledTime,
      priority: Priority.low,
      type: 'wrapup',
      actions: ['rollover'],
    );
  }

  /// Schedules streak at risk reminder (3 hours before midnight)
  Future<void> scheduleStreakAtRisk(
      int currentStreak, bool tasksDoneToday) async {
    if (tasksDoneToday || currentStreak == 0) return;

    final now = DateTime.now();
    final scheduledTime = DateTime(now.year, now.month, now.day, 21); // 9 PM

    if (scheduledTime.isAfter(now)) {
      await _scheduleNotification(
        id: 2001,
        title: 'Streak at risk',
        body:
            'Your $currentStreak-day streak ends in 3hrs. Complete one task to keep it alive.',
        scheduledTime: scheduledTime,
        priority: Priority.high,
        type: 'streak_at_risk',
      );
    }
  }

  /// Schedules streak milestone celebration
  Future<void> scheduleStreakMilestone(int milestone) async {
    final milestones = [7, 14, 30, 60, 100];
    if (!milestones.contains(milestone)) return;

    await _scheduleNotification(
      id: 2002,
      title: 'Streak milestone',
      body:
          '$milestone-day streak. That\'s a habit. You\'ve completed tasks every day this month.',
      scheduledTime: DateTime.now(), // Fire immediately on achievement
      priority: Priority.low,
      type: 'milestone',
    );
  }

  /// Schedules weekly review (Sunday evening)
  Future<void> scheduleWeeklyReview(int tasksCompleted) async {
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, 19); // 7 PM

    // Adjust to next Sunday if not Sunday or already past 7 PM
    int daysUntilSunday = (DateTime.sunday - now.weekday) % 7;
    if (daysUntilSunday == 0 && now.hour >= 19) {
      daysUntilSunday = 7;
    }
    scheduledTime = scheduledTime.add(Duration(days: daysUntilSunday));

    await _scheduleNotification(
      id: 3001,
      title: 'Weekly review ready',
      body:
          'Your week in review is ready. You completed $tasksCompleted tasks. Best week yet.',
      scheduledTime: scheduledTime,
      priority: Priority.low,
      type: 'weekly_review',
    );
  }

  /// Helper to schedule with Anti-Spam, Quiet Hours, and Grouping
  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required Priority priority,
    required String type,
    List<String>? actions,
  }) async {
    // 1. Apply Anti-Spam Rules
    if (!await _shouldFire(type, priority)) return;

    // 2. Respect Quiet Hours (10 PM - 8 AM)
    final finalTime = _adjustForQuietHours(scheduledTime);

    // 3. Android Details with Grouping
    final androidDetails = AndroidNotificationDetails(
      'todo_advanced',
      'Advanced Reminders',
      channelDescription: 'Smart notifications with anti-spam rules',
      importance: _mapPriorityToImportance(priority),
      priority: priority,
      groupKey: 'com.kshitijcodecraft.tasktrackr.TASK_GROUP',
      actions: actions?.map((a) {
        if (a == 'reschedule') {
          return const AndroidNotificationAction('reschedule', 'Reschedule',
              showsUserInterface: true);
        }
        if (a == 'rollover') {
          return const AndroidNotificationAction('rollover', 'Roll over',
              showsUserInterface: true);
        }
        return const AndroidNotificationAction('unknown', 'Action');
      }).toList(),
    );

    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(finalTime, tz.local),
      NotificationDetails(
          android: androidDetails,
          iOS: const DarwinNotificationDetails(threadIdentifier: 'task_group')),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    // Increment daily count
    await _incrementNotificationCount();
  }

  DateTime _adjustForQuietHours(DateTime time) {
    if (time.hour >= 22) {
      // If after 10 PM, move to 8 AM next day
      return DateTime(time.year, time.month, time.day + 1, 8);
    } else if (time.hour < 8) {
      // If before 8 AM, move to 8 AM same day
      return DateTime(time.year, time.month, time.day, 8);
    }
    return time;
  }

  Future<bool> _shouldFire(String type, Priority priority) async {
    // Critical (Overdue) alerts always fire
    if (type == 'overdue') return true;

    final prefs = await SharedPreferences.getInstance();

    // Engagement check: If no tap in 2 weeks, ask once
    final lastTapStr = prefs.getString('last_notif_tap');
    if (lastTapStr != null) {
      final lastTap = DateTime.parse(lastTapStr);
      final daysSinceTap = DateTime.now().difference(lastTap).inDays;
      
      if (daysSinceTap > 14) {
        final hasAsked = prefs.getBool('asked_engagement') ?? false;
        if (!hasAsked) {
          await _scheduleNotification(
            id: 9999,
            title: 'Still want these reminders?',
            body: 'We noticed you haven\'t tapped a notification in a while.',
            scheduledTime: DateTime.now().add(const Duration(hours: 1)),
            priority: Priority.defaultPriority,
            type: 'engagement_prompt',
          );
          await prefs.setBool('asked_engagement', true);
        }
        
        // Reduce frequency logic
        if (priority.value < Priority.high.value) return false;
      }
    }

    final today = DateTime.now().toIso8601String().substring(0, 10);
    final count = prefs.getInt('notif_count_$today') ?? 0;

    // Never fire more than 3 per day
    if (count >= 3) return false;

    return true;
  }

  Future<void> _incrementNotificationCount() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final count = prefs.getInt('notif_count_$today') ?? 0;
    await prefs.setInt('notif_count_$today', count + 1);
  }

  Importance _mapPriorityToImportance(Priority priority) {
    if (priority == Priority.max) return Importance.max;
    if (priority == Priority.high) return Importance.high;
    return Importance.defaultImportance;
  }

  void _handleNotificationAction(NotificationResponse details) async {
    log('Action tapped: ${details.actionId}');
    
    // Update engagement
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_notif_tap', DateTime.now().toIso8601String());

    if (details.actionId == 'reschedule') {
      if (details.payload != null) {
        onReschedule?.call(details.payload!);
      }
    } else if (details.actionId == 'rollover') {
      onRollover?.call();
    }
  }

  // Static method for background message handling
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    log('Handling a background message: ${message.messageId}');
  }
}
