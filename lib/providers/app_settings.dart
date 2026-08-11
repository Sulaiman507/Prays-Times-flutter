import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/city.dart';
import '../models/prayer_type.dart';

/// إعدادات التطبيق — محفوظة محلياً عبر SharedPreferences
class AppSettings extends ChangeNotifier {
  // ---------- المفاتيح ----------
  static const _kLang = 'lang';
  static const _kTimeFormat = 'time_format_24h';
  static const _kDarkMode = 'dark_mode';
  static const _kFontAr = 'font_ar';
  static const _kFontEn = 'font_en';
  static const _kCityId = 'city_id';
  static const _kIqamaPrefix = 'iqama_'; // مفتاح مستقل لكل صلاة

  // ---------- الحالة ----------
  String _lang = 'ar'; // 'ar' أو 'en'
  bool _time24h = false; // false = 12 ساعة
  bool _darkMode = true; // الوضع الداكن افتراضياً
  String _fontAr = 'Tajawal'; // خط العربية
  String _fontEn = 'Tajawal'; // خط الإنجليزية
  String _cityId = 'mecca'; // مكة المكرمة افتراضياً

  /// دقائق الإقامة لكل صلاة على حدة (القيمة الافتراضية: 15 دقيقة)
  final Map<PrayerType, int> _iqamaOffsets = {
    PrayerType.fajr: 15,
    PrayerType.dhuhr: 15,
    PrayerType.asr: 15,
    PrayerType.maghrib: 15,
    PrayerType.isha: 15,
  };

  bool _loaded = false;

  // ---------- Getters ----------
  String get lang => _lang;
  bool get isAr => _lang == 'ar';
  bool get time24h => _time24h;
  bool get darkMode => _darkMode;
  String get fontAr => _fontAr;
  String get fontEn => _fontEn;
  String get cityId => _cityId;
  bool get loaded => _loaded;

  /// دقائق الإقامة لصلاة معينة
  int iqamaFor(PrayerType p) => _iqamaOffsets[p] ?? 15;

  // ---------- Setters (يحفظ تلقائياً) ----------
  set lang(String v) {
    _lang = v;
    notifyListeners();
    _save();
  }

  set time24h(bool v) {
    _time24h = v;
    notifyListeners();
    _save();
  }

  set darkMode(bool v) {
    _darkMode = v;
    notifyListeners();
    _save();
  }

  set fontAr(String v) {
    _fontAr = v;
    notifyListeners();
    _save();
  }

  set fontEn(String v) {
    _fontEn = v;
    notifyListeners();
    _save();
  }

  set cityId(String v) {
    _cityId = v;
    notifyListeners();
    _save();
  }

  /// تحديد دقائق الإقامة لصلاة معينة (0–60)
  void setIqama(PrayerType p, int v) {
    _iqamaOffsets[p] = v < 0 ? 0 : (v > 60 ? 60 : v);
    notifyListeners();
    _save();
  }

  // ---------- التحميل والحفظ ----------
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _lang = prefs.getString(_kLang) ?? 'ar';
    _time24h = prefs.getBool(_kTimeFormat) ?? false;
    _darkMode = prefs.getBool(_kDarkMode) ?? true;
    _fontAr = prefs.getString(_kFontAr) ?? 'Tajawal';
    _fontEn = prefs.getString(_kFontEn) ?? 'Tajawal';
    _cityId = prefs.getString(_kCityId) ?? 'mecca';
    for (final p in _iqamaOffsets.keys) {
      _iqamaOffsets[p] = prefs.getInt('$_kIqamaPrefix${p.id}') ?? 15;
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLang, _lang);
    await prefs.setBool(_kTimeFormat, _time24h);
    await prefs.setBool(_kDarkMode, _darkMode);
    await prefs.setString(_kFontAr, _fontAr);
    await prefs.setString(_kFontEn, _fontEn);
    await prefs.setString(_kCityId, _cityId);
    for (final entry in _iqamaOffsets.entries) {
      await prefs.setInt('$_kIqamaPrefix${entry.key.id}', entry.value);
    }
  }

  /// حفظ المدينة المختارة (مع اسم المدن الكامل)
  Future<void> setCity(City city) async {
    _cityId = city.id;
    notifyListeners();
    await _save();
  }
}
