import 'package:flutter/material.dart';

/// لوحة الألوان الفاخرة: كحلي عميق، ذهبي هادئ، زيتي مريح، أسود دافئ
class AppColors {
  // ---------- اللون الأساسي: الكحلي الفاخر ----------
  static const navy = Color(0xFF1A2A44);
  static const navyDeep = Color(0xFF101B30);
  static const navyLight = Color(0xFF24406B);

  // ---------- الذهبي الهادئ ----------
  static const gold = Color(0xFFC9A24B);
  static const goldLight = Color(0xFFE3C877);
  static const goldDark = Color(0xFF9A7B2F);

  // ---------- الأخضر الزيتي الهادئ ----------
  static const olive = Color(0xFF5B6B4B);
  static const oliveLight = Color(0xFF7C8F66);

  // ---------- درجات الأسود الدافئ للوضع الداكن ----------
  static const warmBlack = Color(0xFF12151C);
  static const warmBlackLight = Color(0xFF1B2029);
  static const cardDark = Color(0xFF1E2530);

  // ---------- الأبيض الكريمي للوضع الفاتح ----------
  static const cream = Color(0xFFF7F3EA);
  static const creamDark = Color(0xFFEDE6D6);

  // ---------- نصوص ----------
  static const textLight = Color(0xFFF5F1E8);
  static const textMuted = Color(0xFF9AA3B2);
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
        seedColor: AppColors.navy,
        brightness: Brightness.dark,
        primary: AppColors.navyLight,
        secondary: AppColors.gold,
        surface: AppColors.warmBlackLight,
      ),
    );
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.warmBlack,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.warmBlack,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
