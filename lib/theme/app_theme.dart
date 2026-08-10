import 'package:flutter/material.dart';

/// لوحة الألوان الفاخرة: زمردي عميق (زيتي)، ذهبي هادئ، كحلي ليلي
class AppColors {
  // ---------- اللون الأساسي: الزمردي/الزيتي الفاخر ----------
  static const emerald = Color(0xFF1B5B47);
  static const emeraldLight = Color(0xFF2E7D5B);
  static const emeraldDeep = Color(0xFF0D2620);
  static const emeraldBlack = Color(0xFF081712);

  // ---------- الذهبي الهادئ ----------
  static const gold = Color(0xFFC9A24B);
  static const goldLight = Color(0xFFE8CE8C);
  static const goldDark = Color(0xFF9A7B2F);

  // ---------- الكحلي الليلي (للوضع الفاتح والبطاقات) ----------
  static const navy = Color(0xFF1A2A44);
  static const navyDeep = Color(0xFF0D1526);
  static const navyLight = Color(0xFF24406B);

  // ---------- درجات الليل الزمردي للوضع الداكن ----------
  static const night = Color(0xFF081712); // خلفية أساسية (أسود مخضر)
  static const nightRaised = Color(0xFF0D2620); // بطاقات (زمردي داكن)
  static const cardDark = Color(0xFF12352A); // بطاقات مرتفعة
  static const nightBorder = Color(0xFF1B5B47); // حدود زمردية

  // ---------- الأبيض الكريمي للوضع الفاتح ----------
  static const cream = Color(0xFFF7F3EA);
  static const creamDark = Color(0xFFEDE6D6);

  // ---------- نصوص ----------
  static const textLight = Color(0xFFF2EDE3);
  static const textMuted = Color(0xFF9AA3B2);
  static const textMutedDark = Color(0xFF8FA398);
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
        seedColor: AppColors.emerald,
        brightness: Brightness.dark,
        primary: AppColors.emeraldLight,
        secondary: AppColors.gold,
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
        valueIndicatorColor: AppColors.emeraldLight,
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
