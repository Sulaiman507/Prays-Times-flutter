import 'package:flutter/material.dart';

import '../providers/app_settings.dart';
import '../providers/prayer_provider.dart';
import '../theme/app_theme.dart';
import 'countdown_timer.dart';
import 'prayer_scene.dart';

/// الترويسة العلوية — بلا صندوق نهائياً:
/// مشهد سماوي يمتد بعرض الشاشة كاملاً ويذوب تدريجياً في الخلفية
/// من الأعلى (خلف الشريط) ومن الأسفل (فوق قائمة الصلوات)
class HeaderCard extends StatelessWidget {
  final PrayerProvider provider;
  final AppSettings settings;

  const HeaderCard({super.key, required this.provider, required this.settings});

  @override
  Widget build(BuildContext context) {
    final city = provider.city;
    final today = provider.today!;
    final lang = settings.lang;
    final isDark = settings.darkMode;

    // التاريخ: ميلادي + هجري (تنسيق بسيط)
    final d = today.date;
    final gregorian = '${d.day} ${_monthName(d.month, lang)} ${d.year}';

    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        children: [
          // المشهد السماوي حسب الصلاة الحالية — يملأ العرض كاملاً بلا حدود
          Positioned.fill(
            child: PrayerScene(prayer: provider.currentPrayer, isDark: isDark),
          ),
          // تدرج علوي وسفلي يذوبان في لون الخلفية (بدل الصندوق والحدود)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.32, 1.0],
                  colors: [
                    isDark
                        ? AppColors.darkBgTop.withOpacity(0.92)
                        : AppColors.lightBgTop.withOpacity(0.92),
                    Colors.transparent,
                    isDark
                        ? AppColors.darkBgTop.withOpacity(0.96)
                        : AppColors.lightBgTop.withOpacity(0.96),
                  ],
                ),
              ),
            ),
          ),
          // المحتوى: نصوص نظيفة بلا أي خلفية
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // المدينة
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: AppColors.goldLight,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        city == null
                            ? ''
                            : '${city.name(lang)} — ${city.country(lang)}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(color: Colors.black45, blurRadius: 6),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  gregorian,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 6)],
                  ),
                ),
                const SizedBox(height: 22),

                // الصلاة القادمة
                Text(
                  lang == 'ar' ? 'الصلاة القادمة' : 'Next Prayer',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    letterSpacing: 0.5,
                    shadows: const [
                      Shadow(color: Colors.black45, blurRadius: 6),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  provider.nextPrayerName,
                  style: const TextStyle(
                    color: AppColors.goldLight,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                  ),
                ),
                const SizedBox(height: 14),

                // العدّاد التنازلي
                CountdownTimer(provider: provider),

                const SizedBox(height: 4),
                Text(
                  '${lang == 'ar' ? 'متبقي على' : 'Time remaining until'} ${provider.nextPrayerName}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 6)],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int m, String lang) {
    const ar = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    const en = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return lang == 'ar' ? ar[m - 1] : en[m - 1];
  }
}
