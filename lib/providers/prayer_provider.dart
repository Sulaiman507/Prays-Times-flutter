import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/city_repository.dart';
import '../models/city.dart';
import '../models/prayer_type.dart';
import '../services/prayer_time_service.dart';
import 'app_settings.dart';

/// مزوّد الحالة الرئيسي — يحسب المواقيت ويحدّث العدّاد كل ثانية
class PrayerProvider extends ChangeNotifier {
  final AppSettings settings;
  final CityRepository _cityRepo = CityRepository();

  City? _city;
  DailyPrayerTimes? _today;
  DateTime _now = DateTime.now();
  Timer? _ticker;

  PrayerProvider(this.settings) {
    _startTicker();
  }

  City? get city => _city;
  DailyPrayerTimes? get today => _today;
  DateTime get now => _now;

  /// تحميل المدينة المحفوظة وحساب المواقيت
  Future<void> init() async {
    final savedId = settings.cityId;
    _city = await _cityRepo.byId(savedId) ?? await _cityRepo.byId('mecca');
    _recompute();
    notifyListeners();
  }

  /// اختيار مدينة جديدة وإعادة الحساب
  Future<void> selectCity(City city) async {
    _city = city;
    await settings.setCity(city);
    _recompute();
    notifyListeners();
  }

  /// بحث في المدن
  Future<List<City>> searchCities(String query) =>
      _cityRepo.search(query, lang: settings.lang);

  /// إعادة حساب المواقيت (تُستدعى عند تغيير المدينة أو منتصف الليل)
  void _recompute() {
    final c = _city;
    if (c == null) return;
    _today = PrayerTimeService.compute(c, now: _now);
  }

  /// تحديث الساعة كل ثانية + إعادة الحساب عند منتصف الليل
  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _now = DateTime.now();
      // إعادة حساب المواقيت عند تغيير اليوم
      final t = _today;
      if (t != null && _now.day != t.date.day) {
        _recompute();
      }
      notifyListeners();
    });
  }

  /// الوقت المتبقي للصلاة القادمة
  Duration get remainingToNext {
    final t = _today;
    if (t == null) return Duration.zero;
    final diff = t.nextPrayerTime.difference(_now);
    return diff.isNegative ? Duration.zero : diff;
  }

  /// وقت الإقامة (الأذان + الإزاحة)
  DateTime iqamaTime(PrayerType p) {
    final t = _today?.timeOf(p);
    if (t == null) return _now;
    return t.add(Duration(minutes: settings.iqamaOffset));
  }

  /// اسم الصلاة القادمة باللغة الحالية
  String get nextPrayerName => _today?.nextPrayer.name(settings.lang) ?? '';

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
