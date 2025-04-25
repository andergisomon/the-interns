import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../dataframe/medical_adherence_df.dart'; // Import your MedicalAdherence model
import '../services/medical_adherence_service.dart'; // Import your service to fetch adherence data
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lebui_modsu/globals.dart';


class NotificationsService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  final MedicalAdherenceService _adherenceService = MedicalAdherenceService(); // Instance of adherence service

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // INITIALIZE
  Future<void> initNotification() async {
    if (isInitialized) return; // Avoid re-initializing

    // Initialize timezone handling
    tz.initializeTimeZones();
    final String currentTimeZone = tz.local.name;
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    // Prepare Android init settings
    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');

    // Prepare iOS init settings
    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Init settings
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    // Initialize the plugin
    await notificationsPlugin.initialize(initSettings);
    _isInitialized = true;
  }

  // Notifications detail setup
  NotificationDetails notificationsDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'medication_channel',
        'Medication Reminders',
        channelDescription: 'Reminders to take medication',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  // SHOW NOTIFICATION
  Future<void> showNotification(int id, String title, String body) async {
    await notificationsPlugin.show(
      id,
      title,
      body,
      notificationsDetails(),
    );
  }

  // SCHEDULE NOTIFICATION
  Future<void> scheduleNotification({
    int id = 0,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    // Schedule for the next occurrence of the specified time
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the scheduled time is in the past, schedule it for the next day
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationsDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // FETCH MEDICAL ADHERENCE DATA AND SCHEDULE NOTIFICATIONS
  Future<void> scheduleAdherenceNotifications() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      // Fetch all medical adherence data
      if (user == null) {
        print('Error: User is not logged in.');
        return;
      }

      final List<MedicalAdherence> adherenceList =
          await _adherenceService.getMedicalAdherence(assignedClinicId!, user.uid);


      int notificationId = 0; // Unique ID for each notification

      for (final adherence in adherenceList) {
        for (final reminder in adherence.reminderTimes) {
          final int hour = reminder['hour']!;
          final int minute = reminder['minute']!;

          // Schedule a notification for each reminder time
          await scheduleNotification(
            id: notificationId++,
            title: 'Medication Reminder',
            body:
                'It\'s time to take your medication: ${adherence.medicationName} (${adherence.dosage} ${adherence.unit})',
            hour: hour,
            minute: minute,
          );
        }
      }
    } catch (e) {
      print('Error scheduling adherence notifications: $e');
    }
  }
}