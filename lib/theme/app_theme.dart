import 'package:flutter/material.dart';

/// لوحة الألوان الفاخرة: كحلي عميق، ذهبي هادئ، زمردي غني
class AppColors {
  // ---------- الذهبي الهادئ ----------
  static const gold = Color(0xFFC9A24B);
  static const goldLight = Color(0xFFE8CE8C);
  static const goldDark = Color(0xFF9A7B2F);

  // ---------- الكحلي العميق ----------
  static const navy = Color(0xFF1E3A8A);
  static const navyDeep = Color(0xFF0F1E4E);
  static const navyLight = Color(0xFF3B5BA8);

  // ---------- الزمردي الغني ----------
  static const emerald = Color(0xFF1B5B47);
  static const emeraldLight = Color(0xFF2E7D5B);
  static const emeraldDeep = Color(0xFF0D2620);
  static const emeraldBlack = Color(0xFF050D0A);

  // ---------- تدرجات الوضع الفاتح ----------
  static const lightBgTop = Color(0xFFF7F3EA); // كريمي
  static const lightBgMid = Color(0xFFF0E6CE); // ذهبي فاتح
  static const lightBgBottom = Color(0xFFE3ECF5); // سماوي ناعم

  // ---------- تدرجات الوضع الداكن ----------
  static const darkBgTop = Color(0xFF050D0A); // أسود مخضر
  static const darkBgMid = Color(0xFF0D2620); // زمردي عميق
  static const darkBgBottom = Color(0xFF0F2E28); // زمردي فاتح

  // ---------- درجات الليل ----------
  static const night = Color(0xFF081712);
  static const nightRaised = Color(0xFF0D2620);
  static const cardDark = Color(0xFF12352A);
  static const nightBorder = Color(0xFF1B5B47);

  // ---------- نصوص ----------
  static const textLight = Color(0xFFF2EDE3);
  static const textMuted = Color(0xFF9AA3B2);
  static const textMutedDark = Color(0xFF8FA398);
  static const textDark = Color(0xFF1A2434);
  static const cream = Color(0xFFF7F3EA);

  // ---------- توهجات (Glow) ----------
  static const glowGold = Color(0x33C9A24B); // ذهبي شفاف
  static const glowEmerald = Color(0x332E7D5B); // زمردي شفاف
  static const glowNavy = Color(0x331E3A8A); // كحلي شفاف
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
        surface: Colors.white.withOpacity(0.7),
      ),
    );
    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withOpacity(0.65),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: AppColors.gold.withOpacity(0.25)),
        ),
      ),
      dividerTheme: DividerThemeData(color: Colors.black.withOpacity(0.06)),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.navy,
        textColor: AppColors.textDark,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.navy,
        inactiveTrackColor: AppColors.navy.withOpacity(0.15),
        thumbColor: AppColors.gold,
        overlayColor: AppColors.gold.withOpacity(0.15),
        valueIndicatorColor: AppColors.navy,
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((_) => AppColors.navy),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white.withOpacity(0.6),
        selectedColor: AppColors.gold,
        side: BorderSide(color: AppColors.gold.withOpacity(0.3)),
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
        surface: AppColors.nightRaised.withOpacity(0.6),
      ),
    );
    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: AppColors.nightRaised.withOpacity(0.55),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: AppColors.gold.withOpacity(0.18)),
        ),
      ),
      dividerTheme: DividerThemeData(color: Colors.white.withOpacity(0.06)),
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

  /// التدرج الخلفي للوضع الفاتح
  static const lightBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.lightBgTop,
      AppColors.lightBgMid,
      AppColors.lightBgBottom,
    ],
  );

  /// التدرج الخلفي للوضع الداكن
  static const darkBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.darkBgTop, AppColors.darkBgMid, AppColors.darkBgBottom],
  );

  /// خلفية البطاقة الزجاجية (Glassmorphism)
  static BoxDecoration glassCard({
    required bool isDark,
    double radius = 24,
    double opacity = 0.6,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [
                Colors.white.withOpacity(0.07),
                AppColors.nightRaised.withOpacity(opacity),
              ]
            : [Colors.white.withOpacity(0.75), Colors.white.withOpacity(0.45)],
      ),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: isDark
            ? AppColors.gold.withOpacity(0.15)
            : AppColors.gold.withOpacity(0.25),
        width: 0.8,
      ),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.35)
              : AppColors.navy.withOpacity(0.08),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  /// تدرج ذهبي فاخر للعناصر المميزة
  static const goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.goldLight, AppColors.gold, AppColors.goldDark],
  );
}
