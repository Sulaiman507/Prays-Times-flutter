import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/city.dart';

/// مستودع المدن — يحمّل قاعدة البيانات من assets/data/cities.json
/// (يعمل 100% بدون إنترنت)
class CityRepository {
  List<City> _cities = [];
  bool _loaded = false;

  Future<List<City>> load() async {
    if (_loaded) return _cities;
    final raw = await rootBundle.loadString('assets/data/cities.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    _cities = (data['cities'] as List)
        .map((e) => City.fromJson(e as Map<String, dynamic>))
        .toList();
    _loaded = true;
    return _cities;
  }

  /// البحث عن مدينة بالمعرّف
  Future<City?> byId(String id) async {
    final cities = await load();
    for (final c in cities) {
      if (c.id == id) return c;
    }
    return null;
  }

  /// البحث النصي بالعربية أو الإنجليزية
  Future<List<City>> search(String query, {String lang = 'ar'}) async {
    final cities = await load();
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return cities;
    return cities.where((c) {
      final name = lang == 'ar' ? c.nameAr : c.nameEn;
      final country = lang == 'ar' ? c.countryAr : c.countryEn;
      return name.toLowerCase().contains(q) ||
          country.toLowerCase().contains(q) ||
          c.nameEn.toLowerCase().contains(q) ||
          c.nameAr.contains(q);
    }).toList();
  }

  /// قائمة الدول الفريدة (للتجميع في شاشة اختيار المدينة)
  Future<Map<String, List<City>>> groupByCountry(String lang) async {
    final cities = await load();
    final map = <String, List<City>>{};
    for (final c in cities) {
      final key = lang == 'ar' ? c.countryAr : c.countryEn;
      map.putIfAbsent(key, () => []).add(c);
    }
    return map;
  }
}
