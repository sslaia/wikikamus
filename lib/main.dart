import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wikikamus/pages/settings_page.dart';

import 'package:wikikamus/providers/locale_provider.dart';
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
  final initialLanguageCode = await getInitialLanguageCode();
  final initialMainPageTitle = await getMainPageTitle();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('id'), Locale('nia')],
      // supportedLocales: const [Locale('bew'), Locale('bjn'), Locale('btm'), Locale('en'), Locale('gor'), Locale('id'), Locale('mad'), Locale('min'), Locale('ms'), Locale('nia'), Locale('su')],
      startLocale: Locale(initialLanguageCode),
      fallbackLocale: const Locale('id'),
      path: 'assets/translations',
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => FontSizeProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider(Locale(initialLanguageCode))),
          ChangeNotifierProxyProvider<LocaleProvider, SettingsProvider>(
            create: (context) => SettingsProvider(
              Provider.of<LocaleProvider>(context, listen: false),
            ),
            update: (context, localeProvider, previousSettingsProvider) =>
            previousSettingsProvider ?? SettingsProvider(localeProvider),
          ),
        ],
        child: Consumer2<ThemeProvider, FontSizeProvider>(
          builder: (context, themeProvider, fontSizeProvider, child) {
            final bool onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

            return MyApp(
                themeProvider: themeProvider,
                fontSizeProvider: fontSizeProvider,
                languageCode: initialLanguageCode,
                mainPageTitle: initialMainPageTitle,
                onboardingComplete: onboardingComplete,
            );
          },
        ),
      ),
    ),
  );
}

Future<String> getInitialLanguageCode() async {
  final prefs = await SharedPreferences.getInstance();
  final languageCode = prefs.getString('user_language_code');

  if (languageCode != null) {
    return languageCode;
  }
  // Default languageCode if nothing is saved
  return 'id';
}

Future<String> getMainPageTitle() async {
  final prefs = await SharedPreferences.getInstance();
  final mainPageTitle = prefs.getString('user_main_page_title');

  if (mainPageTitle != null) {
    return mainPageTitle;
  }
  // Default main page if nothing is saved
  return 'Wikikamus:Halaman Utama';
}

class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  final FontSizeProvider fontSizeProvider;
  final String languageCode;
  final String mainPageTitle;
  final bool onboardingComplete;

  const MyApp({
    super.key,
    required this.themeProvider,
    required this.fontSizeProvider,
    required this.languageCode,
    required this.mainPageTitle,
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
        const NiaMaterialLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppThemes.getLightTheme(fontScale),
      darkTheme: AppThemes.getDarkTheme(fontScale),
      themeMode: themeProvider.themeMode,
        initialRoute: onboardingComplete ? '/' : '/onboarding',
        routes: {
          '/': (context) => HomePage(languageCode: languageCode, mainPageTitle: mainPageTitle),
          '/settings': (context) => const SettingsPage(),
          '/onboarding': (context) => const OnboardingPage(),
        },
      // home: (onboardingComplete)
      //     ? HomePage(languageCode: languageCode, mainPageTitle: mainPageTitle)
      //     : const OnboardingPage(),
    );
  }
}
