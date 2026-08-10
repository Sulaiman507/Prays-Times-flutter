/// نموذج المدينة — يُحمّل من cities.json المحلي (يعمل بدون إنترنت)
class City {
  final String id;
  final String nameAr;
  final String nameEn;
  final String countryAr;
  final String countryEn;
  final double lat;
  final double lng;
  final String tz;

  const City({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.countryAr,
    required this.countryEn,
    required this.lat,
    required this.lng,
    required this.tz,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json['id'] as String,
        nameAr: json['name_ar'] as String,
        nameEn: json['name_en'] as String,
        countryAr: json['country_ar'] as String,
        countryEn: json['country_en'] as String,
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
        tz: json['tz'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_ar': nameAr,
        'name_en': nameEn,
        'country_ar': countryAr,
        'country_en': countryEn,
        'lat': lat,
        'lng': lng,
        'tz': tz,
      };

  /// اسم المدينة حسب اللغة الحالية
  String name(String lang) => lang == 'ar' ? nameAr : nameEn;

  /// اسم الدولة حسب اللغة الحالية
  String country(String lang) => lang == 'ar' ? countryAr : countryEn;
}
