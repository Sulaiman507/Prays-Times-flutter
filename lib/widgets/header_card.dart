import 'package:flutter/material.dart';

import '../providers/app_settings.dart';
import '../providers/prayer_provider.dart';
import '../theme/app_theme.dart';
import 'countdown_timer.dart';
import 'prayer_scene.dart';

/// البطاقة العلوية: مشهد سماوي ديناميكي حسب الصلاة الحالية
/// + اسم المدينة + التاريخ + اسم الصلاة القادمة + العدّاد
class HeaderCard extends StatelessWidget {
  final PrayerProvider provider;
  final AppSettings settings;

  const HeaderCard({super.key, required this.provider, required this.settings});

  @override
  Widget build(BuildContext context) {
    final city = provider.city;
    final today = provider.today!;
    final lang = settings.lang;

    // التاريخ: ميلادي + هجري (تنسيق بسيط)
    final d = today.date;
    final gregorian = '${d.day} ${_monthName(d.month, lang)} ${d.year}';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gold.withOpacity(0.7),
            AppColors.gold.withOpacity(0.15),
            AppColors.gold.withOpacity(0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(1.5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26.5),
        child: Stack(
          children: [
            // المشهد السماوي حسب الصلاة الحالية
            Positioned.fill(
              child: PrayerScene(
                prayer: provider.currentPrayer,
                isDark: settings.darkMode,
              ),
            ),
            // طبقة تعتيم خفيفة لإبراز النصوص
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.25),
                      Colors.transparent,
                      Colors.black.withOpacity(0.45),
                    ],
                  ),
                ),
              ),
            ),
            // المحتوى
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // المدينة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.goldLight,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          city == null
                              ? ''
                              : '${city.name(lang)} — ${city.country(lang)}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(color: Colors.black38, blurRadius: 4),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    gregorian,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      shadows: [Shadow(color: Colors.black38, blurRadius: 4)],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // الصلاة القادمة
                  Text(
                    lang == 'ar' ? 'الصلاة القادمة' : 'Next Prayer',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    provider.nextPrayerName,
                    style: const TextStyle(
                      color: AppColors.goldLight,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black45, blurRadius: 6)],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // العدّاد التنازلي
                  CountdownTimer(provider: provider),

                  const SizedBox(height: 8),
                  Text(
                    '${lang == 'ar' ? 'متبقي على' : 'Time remaining until'} ${provider.nextPrayerName}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      shadows: [Shadow(color: Colors.black38, blurRadius: 4)],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
