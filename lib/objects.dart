import 'package:adhan_dart/adhan_dart.dart';

class AdhanForWaktu {
  final bool isAdhanOn;
  final String adhanName;

  const AdhanForWaktu(
      {this.adhanName = "adzan_mustafa_ozcan", this.isAdhanOn = true});
}

class AdzanReminders {
  AdhanForWaktu adzanForShubuh;
  AdhanForWaktu adzanForDhuhur;
  AdhanForWaktu adzanForAshar;
  AdhanForWaktu adzanForMaghrib;
  AdhanForWaktu adzanForIsya;
  Coordinates coordinates;
  CalculationParameters params;

  AdzanReminders({
    this.adzanForShubuh = const AdhanForWaktu(),
    this.adzanForDhuhur = const AdhanForWaktu(),
    this.adzanForAshar = const AdhanForWaktu(),
    this.adzanForMaghrib = const AdhanForWaktu(),
    this.adzanForIsya = const AdhanForWaktu(),
    required this.coordinates,
    required this.params,
  });

  List<AdzanReminder> adzanReminders = [];

  initialization() {
    for (var i = 0; i < 365; i++) {
      DateTime dateTime = DateTime.now().add(Duration(days: i));

      PrayerTimes prayerTimes =
          PrayerTimes(coordinates, dateTime, params, precision: true);
      if (adzanForShubuh.isAdhanOn) {
        adzanReminders.add(AdzanReminder(
            time: prayerTimes.fajr!,
            id: 1 + 5 * i,
            adzan: adzanForShubuh.adhanName,
            waktu: 'Shubuh'));
      }
      if (adzanForDhuhur.isAdhanOn) {
        adzanReminders.add(AdzanReminder(
            time: prayerTimes.dhuhr!,
            id: 2 + 5 * i,
            adzan: adzanForDhuhur.adhanName,
            waktu: 'Dhuhur'));
      }
      if (adzanForAshar.isAdhanOn) {
        adzanReminders.add(AdzanReminder(
            time: prayerTimes.asr!,
            id: 3 + 5 * i,
            adzan: adzanForAshar.adhanName,
            waktu: 'Ashar'));
      }
      if (adzanForMaghrib.isAdhanOn) {
        adzanReminders.add(AdzanReminder(
            time: prayerTimes.maghrib!,
            id: 4 + 5 * i,
            adzan: adzanForMaghrib.adhanName,
            waktu: 'Maghrib'));
      }
      if (adzanForIsya.isAdhanOn) {
        adzanReminders.add(AdzanReminder(
            time: prayerTimes.isha!,
            id: 5 + 5 * i,
            adzan: adzanForIsya.adhanName,
            waktu: 'Isya'));
      }
    }
  }
}

class AdzanReminder {
  int id;
  String adzan;
  String waktu;
  DateTime time;

  AdzanReminder({
    required this.time,
    required this.id,
    required this.adzan,
    required this.waktu,
  });
}
