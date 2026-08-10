# 🕌 Pray Times — تطبيق مواقيت الصلاة (Offline-First)

تطبيق مواقيت صلاة متكامل مبني بـ **Flutter** يعمل **بدون إنترنت** تماماً — جميع الحسابات تتم محلياً على الجهاز.

## ✨ المميزات

- **حساب Offline بالكامل**: خوارزمية فلكية مدمجة (مكتبة `adhan_dart`) — لا حاجة لأي API
- **طريقة أم القرى**: افتراضية لحساب الفجر (18.5°) والعشاء (90 دقيقة بعد المغرب)
- **وقت الأذان + الإقامة**: إزاحة قابلة للتعديل (0-60 دقيقة)
- **368 مدينة عالمية**: قاعدة بيانات محلية (عربية/إنجليزية) مع الإحداثيات والمناطق الزمنية
- **ثنائي اللغة**: عربي (RTL) / إنجليزي (LTR) مع تبديل فوري
- **نظام الوقت**: 12 أو 24 ساعة
- **الوضع الليلي**: داكن (أسود دافئ) / فاتح (كريمي)
- **خطوط**: Tajawal و Amiri للعربية والإنجليزية
- **عدّاد تنازلي**: أنيميشن سلس للصلاة القادمة يتحدث كل ثانية
- **تصميم فاخر**: كحلي عميق × ذهبي هادئ × زيتي مريح

## 📁 البنية

```
lib/
├── main.dart                  # نقطة الدخول + التوطين RTL/LTR
├── models/
│   ├── city.dart              # نموذج المدينة
│   └── prayer_type.dart       # أنواع الصلوات
├── data/
│   └── city_repository.dart   # تحميل المدن من JSON المحلي
├── providers/
│   ├── app_settings.dart      # الإعدادات (SharedPreferences)
│   └── prayer_provider.dart   # الحالة الرئيسية + العدّاد
├── services/
│   └── prayer_time_service.dart  # حساب المواقيت (أم القرى)
├── theme/
│   └── app_theme.dart         # الألوان الفاخرة + الثيمات
├── widgets/
│   ├── countdown_timer.dart   # العدّاد التنازلي
│   ├── header_card.dart       # بطاقة المدينة + العدّاد
│   └── prayer_list.dart       # قائمة الصلوات
└── screens/
    ├── home_screen.dart       # الشاشة الرئيسية
    ├── settings_screen.dart   # الإعدادات
    └── city_selection_screen.dart  # اختيار المدينة
```

## 🧮 شرح الحساب الفلكي المحلي

نستخدم مكتبة [adhan_dart](https://pub.dev/packages/adhan_dart) — وهي تنفيذ Dart لخوارزميات [Adhan](https://github.com/batoulapps/adhan-js) الفلكية المعتمدة عالمياً:

```dart
// lib/services/prayer_time_service.dart
final params = CalculationMethodParameters.ummAlQura();
params.madhab = Madhab.shafi;

final prayerTimes = PrayerTimes(
  coordinates: Coordinates(city.lat, city.lng),
  date: localNow,
  calculationParameters: params,
);
```

**معاملات أم القرى:**
- الفجر: زاوية 18.5° تحت الأفق
- العشاء: 90 دقيقة بعد غروب الشمس
- المذهب: الشافعي (ظل ×1 للعصر)

المناطق الزمنية عبر مكتبة `timezone` — قاعدة بيانات IANA كاملة مدمجة، فتظهر المواقيت بالوقت المحلي الصحيح لكل مدينة حتى بدون إنترنت.

## 🚀 التشغيل

```bash
flutter pub get
flutter run
```

## 🧪 الاختبار

```bash
flutter test
```

## 📦 الحزم

| الحزمة | الاستخدام |
|--------|-----------|
| `adhan_dart` | الحساب الفلكي (أم القرى) |
| `timezone` | المناطق الزمنية IANA |
| `provider` | إدارة الحالة |
| `shared_preferences` | حفظ الإعدادات |
| `hijri` | التاريخ الهجري (اختياري للترقية) |
