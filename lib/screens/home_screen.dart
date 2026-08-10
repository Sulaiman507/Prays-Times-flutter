import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_settings.dart';
import '../providers/prayer_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/header_card.dart';
import '../widgets/prayer_list.dart';
import 'city_selection_screen.dart';
import 'settings_screen.dart';

/// الشاشة الرئيسية — البطاقة العلوية (العدّاد + المدينة) وقائمة المواقيت
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final provider = context.watch<PrayerProvider>();
    final today = provider.today;
    final city = provider.city;
    final isDark = settings.darkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(settings.isAr ? 'مواقيت الصلاة' : 'Prayer Times'),
        actions: [
          IconButton(
            tooltip: settings.isAr ? 'اختيار المدينة' : 'Select city',
            icon: const Icon(Icons.location_on_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CitySelectionScreen()),
            ),
          ),
          IconButton(
            tooltip: settings.isAr ? 'الإعدادات' : 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: today == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => provider.selectCity(city!),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  HeaderCard(provider: provider, settings: settings),
                  const SizedBox(height: 16),
                  PrayerList(provider: provider, settings: settings),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      settings.isAr ? '﴿ وَإِذَا نَادَيْتُمْ إِلَى الصَّلَاةِ ﴾' : '"When the call to prayer is made"',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.textMuted : AppColors.textDark.withOpacity(0.5),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
    );
  }
}
