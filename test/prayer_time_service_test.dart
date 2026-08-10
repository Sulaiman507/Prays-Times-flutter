import 'package:flutter_test/flutter_test.dart';
import 'package:pray_times/services/prayer_time_service.dart';
import 'package:pray_times/models/city.dart';
import 'package:pray_times/models/prayer_type.dart';

void main() {
  group('PrayerTimeService', () {
    // مكة المكرمة — مرجع معروف
    const mecca = City(
      id: 'mecca',
      nameAr: 'مكة المكرمة',
      nameEn: 'Mecca',
      countryAr: 'السعودية',
      countryEn: 'Saudi Arabia',
      lat: 21.3891,
      lng: 39.8579,
      tz: 'Asia/Riyadh',
    );

    test('يحسب 6 مواقيت في اليوم', () {
      final result = PrayerTimeService.compute(mecca, now: DateTime(2026, 8, 10, 12, 0));
      expect(result.times.length, 6);
      for (final t in result.times.values) {
        expect(t, isNotNull);
      }
    });

    test('ترتيب المواقيت صحيح: فجر < شروق < ظهر < عصر < مغرب < عشاء', () {
      final result = PrayerTimeService.compute(mecca, now: DateTime(2026, 8, 10, 12, 0));
      final times = result.times;
      expect(times[PrayerType.fajr]!.isBefore(times[PrayerType.sunrise]!), isTrue);
      expect(times[PrayerType.sunrise]!.isBefore(times[PrayerType.dhuhr]!), isTrue);
      expect(times[PrayerType.dhuhr]!.isBefore(times[PrayerType.asr]!), isTrue);
      expect(times[PrayerType.asr]!.isBefore(times[PrayerType.maghrib]!), isTrue);
      expect(times[PrayerType.maghrib]!.isBefore(times[PrayerType.isha]!), isTrue);
    });

    test('الفجر بعد منتصف الليل والعشاء بعد المغرب بـ 90 دقيقة تقريباً', () {
      final result = PrayerTimeService.compute(mecca, now: DateTime(2026, 8, 10, 12, 0));
      final diff = result.times[PrayerType.isha]!
          .difference(result.times[PrayerType.maghrib]!);
      // أم القرى: العشاء = مغرب + 90 دقيقة
      expect(diff.inMinutes, closeTo(90, 3));
    });

    test('تنسيق 12 ساعة', () {
      final t = DateTime(2026, 1, 1, 16, 30);
      expect(PrayerTimeService.formatTime(t, time24h: false), '4:30 PM');
    });

    test('تنسيق 24 ساعة', () {
      final t = DateTime(2026, 1, 1, 16, 30);
      expect(PrayerTimeService.formatTime(t, time24h: true), '16:30');
    });
  });
}
