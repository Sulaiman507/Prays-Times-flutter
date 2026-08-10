import 'package:flutter/material.dart';

import '../providers/app_settings.dart';
import '../providers/prayer_provider.dart';
import '../theme/app_theme.dart';
import 'countdown_timer.dart';

/// البطاقة العلوية: اسم المدينة + التاريخ + اسم الصلاة القادمة + العدّاد
class HeaderCard extends StatelessWidget {
  final PrayerProvider provider;
  final AppSettings settings;

  const HeaderCard({super.key, required this.provider, required this.settings});

  @override
  Widget build(BuildContext context) {
    final city = provider.city;
    final today = provider.today!;
    final isDark = settings.darkMode;
    final lang = settings.lang;

    // التاريخ: ميلادي + هجري (تنسيق بسيط)
    final d = today.date;
    final gregorian = '${d.day} ${_monthName(d.month, lang)} ${d.year}';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.navyDeep, AppColors.navyLight]
              : [AppColors.navy, AppColors.navyLight],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.navyDeep.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // المدينة
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: AppColors.goldLight, size: 18),
              const SizedBox(width: 6),
              Text(
                city == null ? '' : '${city.name(lang)} — ${city.country(lang)}',
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            gregorian,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // الصلاة القادمة
          Text(
            lang == 'ar' ? 'الصلاة القادمة' : 'Next Prayer',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            provider.nextPrayerName,
            style: const TextStyle(
              color: AppColors.goldLight,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // العدّاد التنازلي
          CountdownTimer(provider: provider),

          const SizedBox(height: 8),
          Text(
            '${lang == 'ar' ? 'متبقي على' : 'Time remaining until'} ${provider.nextPrayerName}',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _monthName(int m, String lang) {
    const ar = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    const en = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return lang == 'ar' ? ar[m - 1] : en[m - 1];
  }
}
