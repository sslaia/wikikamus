import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wikikamus/localizations/bew_material_localizations.dart';
import 'package:wikikamus/localizations/bjn_material_localizations.dart';
import 'package:wikikamus/localizations/btm_material_localizations.dart';
import 'package:wikikamus/localizations/gor_material_localizations.dart';
import 'package:wikikamus/localizations/jv_material_localizations.dart';
import 'package:wikikamus/localizations/mad_material_localizations.dart';
import 'package:wikikamus/localizations/min_material_localizations.dart';
import 'package:wikikamus/localizations/su_material_localizations.dart';

import 'package:wikikamus/pages/settings_page.dart';
import 'package:wikikamus/localizations/nia_material_localizations.dart';
import 'package:wikikamus/pages/onboarding_page.dart';
import 'package:wikikamus/pages/home_page.dart';
import 'package:wikikamus/providers/font_size_provider.dart';
import 'package:wikikamus/providers/settings_provider.dart';
import 'package:wikikamus/providers/theme_provider.dart';
import 'package:wikikamus/themes/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  final prefs = await SharedPreferences.getInstance();
  final initialLanguageCode = settingsProvider.activeLanguageCode;

  runApp(
    EasyLocalization(
      // supportedLocales: const [Locale('en'), Locale('id'), Locale('nia')],
      supportedLocales: const [Locale('bew'), Locale('bjn'), Locale('btm'), Locale('en'), Locale('gor'), Locale('id'), Locale('mad'), Locale('min'), Locale('ms'), Locale('nia'), Locale('su')],
      startLocale: Locale(initialLanguageCode),
      fallbackLocale: const Locale('id'),
      path: 'assets/translations',
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => FontSizeProvider()),
          ChangeNotifierProvider(create: (_) => SettingsProvider(),
          ),
        ],
        child: Consumer2<ThemeProvider, FontSizeProvider>(
          builder: (context, themeProvider, fontSizeProvider, child) {
            final bool onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

            return MyApp(
                themeProvider: themeProvider,
                fontSizeProvider: fontSizeProvider,
                onboardingComplete: onboardingComplete,
            );
          },
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  final FontSizeProvider fontSizeProvider;
  final bool onboardingComplete;

  const MyApp({
    super.key,
    required this.themeProvider,
    required this.fontSizeProvider,
    required this.onboardingComplete,
  });

  @override
  Widget build(BuildContext context) {
    final double fontScale = fontSizeProvider.currentScale;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wikikamus',
      localizationsDelegates: [
        EasyLocalization.of(context)!.delegate,
        const BewMaterialLocalizationsDelegate(),
        const BjnMaterialLocalizationsDelegate(),
        const BtmMaterialLocalizationsDelegate(),
        const GorMaterialLocalizationsDelegate(),
        const JvMaterialLocalizationsDelegate(),
        const MadMaterialLocalizationsDelegate(),
        const MinMaterialLocalizationsDelegate(),
        const NiaMaterialLocalizationsDelegate(),
        const SuMaterialLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppThemes.getLightTheme(fontScale),
      darkTheme: AppThemes.getDarkTheme(fontScale),
      themeMode: themeProvider.themeMode,
        initialRoute: onboardingComplete ? '/settings' : '/onboarding',
        routes: {
          '/': (context) => HomePage(),
          '/settings': (context) => const SettingsPage(),
          '/onboarding': (context) => const OnboardingPage(),
        },
    );
  }
}
