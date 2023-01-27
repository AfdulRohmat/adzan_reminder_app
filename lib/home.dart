import 'package:adhan_app/notification_manager.dart';
import 'package:adhan_app/objects.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workmanager/workmanager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.payload});

  final String payload;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PrayerTimes prayerTimes;
  late DateTime date;
  late Coordinates coordinates;
  late CalculationParameters params;

  bool isLoading = false;
  bool isAdzanNotificationGenerated = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
      isAdzanNotificationGenerated = false;
    });

    coordinates = Coordinates(-6.121435, 106.774124); // JAKARTA LATLONG
    date = DateTime.now();
    params = CalculationMethod.MuslimWorldLeague();
    params.madhab = Madhab.Shafi;
    prayerTimes = PrayerTimes(coordinates, date, params);

    setState(() => isLoading = false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!isAdzanNotificationGenerated) {
      AdzanReminders adzanReminders = AdzanReminders(
        params: params,
        coordinates: coordinates,
        adzanForShubuh: const AdhanForWaktu(adhanName: "adzan_shubuh"),
      );

      adzanReminders.initialization();

      NotificationManager notificationManager = NotificationManager();
      notificationManager.initialize(context);
      notificationManager.cancelNotification();

      for (var adzanReminder in adzanReminders.adzanReminders) {
        notificationManager.setNotification(
            time: adzanReminder.time,
            id: adzanReminder.id,
            waktu: adzanReminder.waktu,
            adzanSound: adzanReminder.adzan);

        setState(() {
          isAdzanNotificationGenerated = true;
        });
      }
    }

    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                const SizedBox(height: 64),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Adhan App",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // TODAY
                const Text(
                  "Hari ini",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat("EEEE, d MMMM yyyy", "id_ID").format(date),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 40),

                // WILAYAH
                const Text(
                  "Jadwal Adzan dan Sholat \n untuk wilayah :",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Jakarta (${coordinates.latitude}, ${coordinates.longitude})",
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 40),

                // ADHAN TIME
                AdhanTimeTile(
                  waktuSholat: "Shubuh",
                  jam:
                      DateFormat('HH:mm:a').format(prayerTimes.fajr!.toLocal()),
                ),
                AdhanTimeTile(
                  waktuSholat: "Dhuhur",
                  jam: DateFormat('HH:mm:a')
                      .format(prayerTimes.dhuhr!.toLocal()),
                ),
                AdhanTimeTile(
                  waktuSholat: "Ashar",
                  jam: DateFormat('HH:mm:a').format(prayerTimes.asr!.toLocal()),
                ),
                AdhanTimeTile(
                  waktuSholat: "Maghrib",
                  jam: DateFormat('HH:mm:a')
                      .format(prayerTimes.maghrib!.toLocal()),
                ),
                AdhanTimeTile(
                  waktuSholat: "Isya",
                  jam:
                      DateFormat('HH:mm:a').format(prayerTimes.isha!.toLocal()),
                ),
              ],
            ),
    );
  }
}

class AdhanTimeTile extends StatelessWidget {
  const AdhanTimeTile({
    super.key,
    required this.waktuSholat,
    required this.jam,
  });

  final String waktuSholat;
  final String jam;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            waktuSholat,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            jam,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
