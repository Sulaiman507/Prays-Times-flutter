import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_settings.dart';
import '../theme/app_theme.dart';

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
      appBar: AppBar(title: Text(lang == 'ar' ? 'الإعدادات' : 'Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
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
          _SectionTitle(text: lang == 'ar' ? 'الإقامة' : 'Iqama'),
          _SettingsCard(
            child: Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  color: isDark ? AppColors.gold : AppColors.navy,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    lang == 'ar'
                        ? 'دقائق الإقامة بعد الأذان'
                        : 'Iqama minutes after Adhan',
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${settings.iqamaOffset} ${lang == 'ar' ? 'د' : 'min'}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.goldDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Slider(
            value: settings.iqamaOffset.toDouble(),
            min: 0,
            max: 60,
            divisions: 12,
            label: '${settings.iqamaOffset} min',
            onChanged: (v) => settings.iqamaOffset = v.round(),
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
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withOpacity(0.12)),
      ),
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
