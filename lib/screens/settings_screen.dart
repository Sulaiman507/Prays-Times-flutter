import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/prayer_type.dart';
import '../providers/app_settings.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_background.dart';

/// شاشة الإعدادات: اللغة، الوقت، الثيم، الخطوط، الإقامة
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final isDark = settings.darkMode;
    final lang = settings.lang;

    // خيارات الخطوط
    const fonts = ['Tajawal', 'Amiri'];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(lang == 'ar' ? 'الإعدادات' : 'Settings')),
      body: GradientBackground(
        isDark: isDark,
        child: ListView(
          padding: const EdgeInsets.only(
            top: 80,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          children: [
            // ---------- اللغة ----------
            _SectionTitle(text: lang == 'ar' ? 'اللغة' : 'Language'),
            _SettingsCard(
              child: Column(
                children: [
                  _RadioTile<String>(
                    value: 'ar',
                    groupValue: settings.lang,
                    onChanged: (v) => settings.lang = v!,
                    icon: Icons.language,
                    title: 'العربية',
                    subtitle: 'RTL',
                  ),
                  _RadioTile<String>(
                    value: 'en',
                    groupValue: settings.lang,
                    onChanged: (v) => settings.lang = v!,
                    icon: Icons.translate,
                    title: 'English',
                    subtitle: 'LTR',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ---------- نظام الوقت ----------
            _SectionTitle(text: lang == 'ar' ? 'نظام الوقت' : 'Time Format'),
            _SettingsCard(
              child: Column(
                children: [
                  _RadioTile<bool>(
                    value: false,
                    groupValue: settings.time24h,
                    onChanged: (v) => settings.time24h = v!,
                    icon: Icons.schedule,
                    title: lang == 'ar' ? '12 ساعة' : '12-hour',
                    subtitle: '4:30 PM',
                  ),
                  _RadioTile<bool>(
                    value: true,
                    groupValue: settings.time24h,
                    onChanged: (v) => settings.time24h = v!,
                    icon: Icons.access_time,
                    title: lang == 'ar' ? '24 ساعة' : '24-hour',
                    subtitle: '16:30',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ---------- المظهر ----------
            _SectionTitle(text: lang == 'ar' ? 'المظهر' : 'Appearance'),
            _SettingsCard(
              child: Column(
                children: [
                  _RadioTile<bool>(
                    value: false,
                    groupValue: settings.darkMode,
                    onChanged: (v) => settings.darkMode = v!,
                    icon: Icons.light_mode,
                    title: lang == 'ar' ? 'الوضع الفاتح' : 'Light Mode',
                    subtitle: lang == 'ar'
                        ? 'خلفية كريمية هادئة'
                        : 'Cream background',
                  ),
                  _RadioTile<bool>(
                    value: true,
                    groupValue: settings.darkMode,
                    onChanged: (v) => settings.darkMode = v!,
                    icon: Icons.dark_mode,
                    title: lang == 'ar' ? 'الوضع الداكن' : 'Dark Mode',
                    subtitle: lang == 'ar'
                        ? 'أسود دافئ مريح للعين'
                        : 'Warm dark background',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ---------- الخطوط ----------
            _SectionTitle(text: lang == 'ar' ? 'الخطوط' : 'Fonts'),
            _SettingsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang == 'ar' ? 'خط العربية' : 'Arabic Font',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _FontChips(
                    options: fonts,
                    selected: settings.fontAr,
                    onSelected: (f) => settings.fontAr = f,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    lang == 'ar' ? 'خط الإنجليزية' : 'English Font',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _FontChips(
                    options: fonts,
                    selected: settings.fontEn,
                    onSelected: (f) => settings.fontEn = f,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ---------- الإقامة ----------
            _SectionTitle(
              text: lang == 'ar' ? 'الإقامة لكل صلاة' : 'Iqama per Prayer',
            ),
            _SettingsCard(
              child: Column(
                children: [
                  for (final p in const [
                    PrayerType.fajr,
                    PrayerType.dhuhr,
                    PrayerType.asr,
                    PrayerType.maghrib,
                    PrayerType.isha,
                  ])
                    _IqamaRow(
                      prayer: p,
                      settings: settings,
                      isDark: isDark,
                      lang: lang,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ---------- حول التطبيق ----------
            _SectionTitle(text: lang == 'ar' ? 'حول التطبيق' : 'About'),
            _SettingsCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.apartment, color: AppColors.gold),
                    title: Text(lang == 'ar' ? 'المؤسسة' : 'Organization'),
                    subtitle: const Text(
                      'S.Muslim',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldDark,
                      ),
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.code, color: AppColors.gold),
                    title: Text(lang == 'ar' ? 'المطوّر' : 'Developer'),
                    subtitle: const Text(
                      'سليمان الرمادي',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldDark,
                      ),
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(
                      Icons.info_outline,
                      color: AppColors.gold,
                    ),
                    title: Text(lang == 'ar' ? 'الإصدار' : 'Version'),
                    subtitle: const Text('1.0.0'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// ---------- عناصر مساعدة ----------

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.goldDark,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;
  const _SettingsCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: AppTheme.glassCard(isDark: isDark, radius: 20, opacity: 0.55),
      child: child,
    );
  }
}

class _RadioTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final IconData icon;
  final String title;
  final String subtitle;

  const _RadioTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Radio<T>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
      onTap: () => onChanged(value),
    );
  }
}

class _FontChips extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  const _FontChips({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        for (final f in options)
          ChoiceChip(
            label: Text(f, style: TextStyle(fontFamily: f)),
            selected: selected == f,
            onSelected: (_) => onSelected(f),
            selectedColor: AppColors.gold.withOpacity(0.2),
            labelStyle: TextStyle(
              color: selected == f ? AppColors.goldDark : null,
              fontFamily: f,
            ),
          ),
      ],
    );
  }
}

/// صف الإقامة لصلاة واحدة: أيقونة + اسم + عدّاد دقائق (− / +)
class _IqamaRow extends StatelessWidget {
  final PrayerType prayer;
  final AppSettings settings;
  final bool isDark;
  final String lang;

  const _IqamaRow({
    required this.prayer,
    required this.settings,
    required this.isDark,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = settings.iqamaFor(prayer);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        AppColors.emerald.withOpacity(0.5),
                        AppColors.nightRaised.withOpacity(0.6),
                      ]
                    : [
                        AppColors.navy.withOpacity(0.15),
                        AppColors.navyLight.withOpacity(0.08),
                      ],
              ),
            ),
            child: Icon(
              _iconFor(prayer),
              size: 16,
              color: isDark ? AppColors.textMutedDark : AppColors.navy,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              prayer.name(lang),
              style: TextStyle(
                fontSize: 15,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
            ),
          ),
          // زر ناقص
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            color: AppColors.gold,
            iconSize: 22,
            onPressed: minutes <= 0
                ? null
                : () => settings.setIqama(prayer, minutes - 1),
          ),
          // القيمة
          Container(
            width: 44,
            alignment: Alignment.center,
            child: Text(
              '$minutes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFeatures: const [FontFeature.tabularFigures()],
                color: isDark ? AppColors.goldLight : AppColors.goldDark,
              ),
            ),
          ),
          // زر زائد
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            color: AppColors.gold,
            iconSize: 22,
            onPressed: minutes >= 60
                ? null
                : () => settings.setIqama(prayer, minutes + 1),
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
