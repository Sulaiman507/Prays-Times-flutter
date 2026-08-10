import 'package:adhan_dart/adhan_dart.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../models/city.dart';
import '../models/prayer_type.dart';

/// نتيجة حساب مواقيت يوم كامل
class DailyPrayerTimes {
  final DateTime date;
  final Map<PrayerType, DateTime> times;
  final PrayerType nextPrayer;
  final DateTime nextPrayerTime;

  DailyPrayerTimes({
    required this.date,
    required this.times,
    required this.nextPrayer,
    required this.nextPrayerTime,
  });

  DateTime timeOf(PrayerType p) => times[p]!;
}

/// خدمة حساب مواقيت الصلاة — Offline بالكامل
/// تعتمد على مكتبة adhan_dart (خوارزميات أم القرى المعتمدة)
class PrayerTimeService {
  static bool _tzInitialized = false;

  /// تهيئة قاعدة بيانات المناطق الزمنية (مرة واحدة)
  static void _ensureTz() {
    if (!_tzInitialized) {
      tzdata.initializeTimeZones();
      _tzInitialized = true;
    }
  }

  /// حساب مواقيت اليوم لمدينة معيّنة بطريقة أم القرى
  static DailyPrayerTimes compute(City city, {DateTime? now}) {
    _ensureTz();
    final current = now ?? DateTime.now();

    // الوقت المحلي للمدينة (حسب المنطقة الزمنية الصحيحة)
    final location = tz.getLocation(city.tz);
    final localNow = tz.TZDateTime.from(current, location);

    // إحداثيات المدينة
    final coordinates = Coordinates(city.lat, city.lng);

    // معاملات أم القرى: فجر 18.5° + العشاء بعد 90 دقيقة من المغرب
    final params = CalculationMethodParameters.ummAlQura();
    params.madhab = Madhab.shafi;

    final prayerTimes = PrayerTimes(
      coordinates: coordinates,
      date: localNow,
      calculationParameters: params,
    );

    // تحويل النتائج إلى الوقت المحلي للمدينة
    DateTime toLocal(DateTime t) => tz.TZDateTime.from(t, location);

    final times = <PrayerType, DateTime>{
      PrayerType.fajr: toLocal(prayerTimes.fajr),
      PrayerType.sunrise: toLocal(prayerTimes.sunrise),
      PrayerType.dhuhr: toLocal(prayerTimes.dhuhr),
      PrayerType.asr: toLocal(prayerTimes.asr),
      PrayerType.maghrib: toLocal(prayerTimes.maghrib),
      PrayerType.isha: toLocal(prayerTimes.isha),
    };

    // الصلاة القادمة
    final next = prayerTimes.nextPrayer(date: localNow);
    final nextType = _mapPrayer(next);
    final nextTime = toLocal(prayerTimes.timeForPrayer(next));

    return DailyPrayerTimes(
      date: localNow,
      times: times,
      nextPrayer: nextType,
      nextPrayerTime: nextTime,
    );
  }

  /// تحويل Prayer من المكتبة إلى PrayerType الخاص بنا
  static PrayerType _mapPrayer(Prayer p) {
    switch (p) {
      case Prayer.fajr:
      case Prayer.fajrAfter:
        return PrayerType.fajr;
      case Prayer.sunrise:
        return PrayerType.sunrise;
      case Prayer.dhuhr:
        return PrayerType.dhuhr;
      case Prayer.asr:
        return PrayerType.asr;
      case Prayer.maghrib:
        return PrayerType.maghrib;
      case Prayer.isha:
      case Prayer.ishaBefore:
        return PrayerType.isha;
    }
  }

  /// تنسيق الوقت حسب إعداد 12/24 ساعة
  static String formatTime(DateTime t, {required bool time24h}) {
    if (time24h) {
      final h = t.hour.toString().padLeft(2, '0');
      final m = t.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    final h12 = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    final suffix = t.hour < 12 ? 'AM' : 'PM';
    return '$h12:$m $suffix';
  }
}
