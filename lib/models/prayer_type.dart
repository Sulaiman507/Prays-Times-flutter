/// أنواع الصلوات الخمس + الشروق (للعرض فقط)
enum PrayerType {
  fajr('الفجر', 'Fajr', 'fajr'),
  sunrise('الشروق', 'Sunrise', 'sunrise'),
  dhuhr('الظهر', 'Dhuhr', 'dhuhr'),
  asr('العصر', 'Asr', 'asr'),
  maghrib('المغرب', 'Maghrib', 'maghrib'),
  isha('العشاء', 'Isha', 'isha');

  final String nameAr;
  final String nameEn;
  final String id;

  const PrayerType(this.nameAr, this.nameEn, this.id);

  String name(String lang) => lang == 'ar' ? nameAr : nameEn;

  static PrayerType fromId(String id) =>
      values.firstWhere((p) => p.id == id, orElse: () => fajr);
}
