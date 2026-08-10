import 'package:flutter/material.dart';

/// لوحة الألوان الفاخرة: كحلي عميق، ذهبي هادئ، زيتي مريح، أسود دافئ
class AppColors {
  // ---------- اللون الأساسي: الكحلي الفاخر ----------
  static const navy = Color(0xFF1A2A44);
  static const navyDeep = Color(0xFF0D1526);
  static const navyLight = Color(0xFF24406B);

  // ---------- الذهبي الهادئ ----------
  static const gold = Color(0xFFC9A24B);
  static const goldLight = Color(0xFFE8CE8C);
  static const goldDark = Color(0xFF9A7B2F);

  // ---------- الأخضر الزيتي الهادئ ----------
  static const olive = Color(0xFF5B6B4B);
  static const oliveLight = Color(0xFF7C8F66);

  // ---------- درجات الليل العميق للوضع الداكن ----------
  static const night = Color(0xFF0B0F17); // خلفية أساسية
  static const nightRaised = Color(0xFF131A26); // بطاقات
  static const nightBorder = Color(0xFF1E2838); // حدود
  static const cardDark = Color(0xFF141C2B);

  // ---------- الأبيض الكريمي للوضع الفاتح ----------
  static const cream = Color(0xFFF7F3EA);
  static const creamDark = Color(0xFFEDE6D6);

  // ---------- نصوص ----------
  static const textLight = Color(0xFFF2EDE3);
  static const textMuted = Color(0xFF9AA3B2);
  static const textMutedDark = Color(0xFF8B95A8);
  static const textDark = Color(0xFF1A2434);
}

/// بناء ThemeData حسب الوضع (داكن/فاتح) والخط المختار
class AppTheme {
  static ThemeData light({required String fontFamily}) {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.navy,
        brightness: Brightness.light,
        primary: AppColors.navy,
        secondary: AppColors.gold,
        surface: AppColors.cream,
      ),
    );
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.cream,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  static ThemeData dark({required String fontFamily}) {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.navyLight,
        brightness: Brightness.dark,
        primary: AppColors.gold,
        secondary: AppColors.goldLight,
        surface: AppColors.nightRaised,
      ),
    );
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.night,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.night,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.nightBorder, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.nightBorder),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.gold,
        textColor: AppColors.textLight,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.gold,
        inactiveTrackColor: AppColors.nightBorder,
        thumbColor: AppColors.goldLight,
        overlayColor: AppColors.gold.withOpacity(0.15),
        valueIndicatorColor: AppColors.navyLight,
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((_) => AppColors.gold),
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: AppColors.nightRaised,
        selectedColor: AppColors.gold,
        side: BorderSide(color: AppColors.nightBorder),
      ),
    );
  }
}
