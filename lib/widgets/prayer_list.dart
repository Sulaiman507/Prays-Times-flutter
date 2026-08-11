import 'package:flutter/material.dart';

import '../models/prayer_type.dart';
import '../providers/app_settings.dart';
import '../providers/prayer_provider.dart';
import '../services/prayer_time_service.dart';
import '../theme/app_theme.dart';

/// قائمة الصلوات: بطاقة زجاجية فاخرة — اسم + وقت الأذان + وقت الإقامة
class PrayerList extends StatelessWidget {
  final PrayerProvider provider;
  final AppSettings settings;

  const PrayerList({super.key, required this.provider, required this.settings});

  static const _prayers = [
    PrayerType.fajr,
    PrayerType.sunrise,
    PrayerType.dhuhr,
    PrayerType.asr,
    PrayerType.maghrib,
    PrayerType.isha,
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = settings.darkMode;
    final next = provider.today!.nextPrayer;
    final lang = settings.lang;

    return Container(
      decoration: AppTheme.glassCard(isDark: isDark, radius: 28),
      child: Column(
        children: [
          for (var i = 0; i < _prayers.length; i++) ...[
            _PrayerRow(
              type: _prayers[i],
              isNext: _prayers[i] == next,
              isDark: isDark,
              lang: lang,
              adhan: PrayerTimeService.formatTime(
                provider.today!.timeOf(_prayers[i]),
                time24h: settings.time24h,
              ),
              iqama: _prayers[i] == PrayerType.sunrise
                  ? null
                  : PrayerTimeService.formatTime(
                      provider.iqamaTime(_prayers[i]),
                      time24h: settings.time24h,
                    ),
            ),
            if (i < _prayers.length - 1)
              Divider(
                height: 1,
                indent: 56,
                endIndent: 16,
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.black.withOpacity(0.05),
              ),
          ],
        ],
      ),
    );
  }
}

/// صف صلاة واحد: الأيقونة، الاسم، الأذان، الإقامة
class _PrayerRow extends StatelessWidget {
  final PrayerType type;
  final bool isNext;
  final bool isDark;
  final String lang;
  final String adhan;
  final String iqama;

  const _PrayerRow({
    required this.type,
    required this.isNext,
    required this.isDark,
    required this.lang,
    required this.adhan,
    required this.iqama,
  });

  @override
  Widget build(BuildContext context) {
    final highlightColor = isNext
        ? (isDark
              ? AppColors.gold.withOpacity(0.14)
              : AppColors.gold.withOpacity(0.12))
        : Colors.transparent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: highlightColor,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // أيقونة الصلاة بتدرج
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isNext
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.goldLight,
                        AppColors.gold,
                        AppColors.goldDark,
                      ],
                    )
                  : (isDark
                        ? LinearGradient(
                            colors: [
                              AppColors.emerald.withOpacity(0.5),
                              AppColors.nightRaised.withOpacity(0.6),
                            ],
                          )
                        : LinearGradient(
                            colors: [
                              AppColors.navy.withOpacity(0.15),
                              AppColors.navyLight.withOpacity(0.08),
                            ],
                          )),
            ),
            child: Icon(
              _iconFor(type),
              color: isNext
                  ? AppColors.navyDeep
                  : (isDark ? AppColors.textMutedDark : AppColors.navy),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // الاسم + شارة "التالي"
          Expanded(
            child: Row(
              children: [
                Text(
                  type.name(lang),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
                    color: isNext
                        ? (isDark ? AppColors.goldLight : AppColors.goldDark)
                        : (isDark ? AppColors.textLight : AppColors.textDark),
                  ),
                ),
                if (isNext) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withOpacity(0.4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Text(
                      lang == 'ar' ? 'التالي' : 'NEXT',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.navyDeep,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // الأذان
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                adhan,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              if (iqama != null)
                Text(
                  '$iqama ${lang == 'ar' ? 'الإقامة' : 'Iqama'}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMuted,
                  ),
                )
              else
                Text(
                  lang == 'ar' ? 'الشروق' : 'Sunrise',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMuted,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _iconFor(PrayerType p) {
    switch (p) {
      case PrayerType.fajr:
        return Icons.wb_twilight;
      case PrayerType.dhuhr:
        return Icons.wb_sunny;
      case PrayerType.asr:
        return Icons.light_mode;
      case PrayerType.maghrib:
        return Icons.nights_stay;
      case PrayerType.isha:
        return Icons.dark_mode;
      case PrayerType.sunrise:
        return Icons.wb_cloudy;
    }
  }
}
