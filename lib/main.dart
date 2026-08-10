import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/app_settings.dart';
import 'providers/prayer_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PrayTimesApp());
}

/// التطبيق الرئيسي — يوفّر Providers ويبني MaterialApp
class PrayTimesApp extends StatefulWidget {
  const PrayTimesApp({super.key});

  @override
  State<PrayTimesApp> createState() => _PrayTimesAppState();
}

class _PrayTimesAppState extends State<PrayTimesApp> {
  late final AppSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = AppSettings();
    _settings.load();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _settings),
        ChangeNotifierProvider(
          create: (ctx) => PrayerProvider(ctx.read<AppSettings>())..init(),
        ),
      ],
      child: Consumer<AppSettings>(
        builder: (context, settings, _) {
          if (!settings.loaded) {
            return const MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          }

          // الخط المختار للعربية والإنجليزية
          final fontFamily = settings.isAr ? settings.fontAr : settings.fontEn;

          return MaterialApp(
            title: 'Pray Times',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(fontFamily: fontFamily),
            darkTheme: AppTheme.dark(fontFamily: fontFamily),
            themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,

            // دعم العربية (RTL) والإنجليزية (LTR)
            locale: Locale(settings.lang),
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
