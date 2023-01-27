import 'package:adhan_app/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('mosque_icon');

InitializationSettings initializationSettings =
    const InitializationSettings(android: initializationSettingsAndroid);

class NotificationManager {
  initialize(BuildContext context) async {
    void onDidReceiveNotificationResponse(
        NotificationResponse notificationResponse) async {
      final String? payload = notificationResponse.payload;
      if (notificationResponse.payload != null) {
        debugPrint('notification payload: $payload');
      }

      await Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (context) => HomeScreen(payload: payload!)),
      );
    }

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  setNotification({
    required DateTime time,
    required int id,
    required String waktu,
    required String adzanSound,
  }) async {
    tz.initializeTimeZones();

    Duration duration = time.difference(DateTime.now());
    if (!duration.isNegative) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          'Waktu Sholat $waktu',
          'Waktu sudah menunjukan jadwal sholat',
          tz.TZDateTime.now(tz.local).add(duration),
          NotificationDetails(
            android: AndroidNotificationDetails(
              'adhan_app_id',
              'adhan_app_name',
              channelDescription: 'adhan_app untuk pengingat waktu sholat',
              fullScreenIntent: true,
              playSound: true,
              sound: RawResourceAndroidNotificationSound(adzanSound),
            ),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
    }
  }

  cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key, required this.payload});
  final String payload;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.notifications),
        onPressed: () async {
          // NotificationManager notificationManager = NotificationManager();
          // notificationManager.initialize(context);
          // notificationManager.setNotification(
          //     id: 1,
          //     time: DateTime.now().add(const Duration(seconds: 2)),
          //     waktu: "Dhuhur");
        },
      ),
      body: Center(
        child: Text(
          "Sudah menunjukan waktu : ${widget.payload}",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
