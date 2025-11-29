import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
import 'package:wikikamus/pages/splash_page.dart';
import 'package:wikikamus/providers/auth_provider.dart';
import 'package:wikikamus/providers/font_size_provider.dart';
import 'package:wikikamus/providers/settings_provider.dart';
import 'package:wikikamus/providers/theme_provider.dart';
import 'package:wikikamus/themes/app_themes.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    final settingsProvider = SettingsProvider();
    await settingsProvider.loadSettings();

    final prefs = await SharedPreferences.getInstance();
    final initialLanguageCode = settingsProvider.activeLanguageCode;

    await dotenv.load(fileName: "wikikamus.env");

    final bool onboardingComplete =
        prefs.getBool('onboarding_complete') ?? false;

    runApp(
      EasyLocalization(
        supportedLocales: const [
          Locale('bew'),
          Locale('bjn'),
          Locale('btm'),
          Locale('en'),
          Locale('gor'),
          Locale('id'),
          Locale('mad'),
          Locale('min'),
          Locale('ms'),
          Locale('nia'),
          Locale('su'),
        ],
        startLocale: Locale(initialLanguageCode),
        fallbackLocale: const Locale('nia'),
        path: 'assets/translations',
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => FontSizeProvider()),
            ChangeNotifierProvider(create: (_) => SettingsProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: MyApp(onboardingComplete: onboardingComplete),
        ),
      ),
    );
  } catch (e) {
    runApp(InitializationErrorApp(error: e.toString()));
  }
}

/// A fallback widget to display when the main app fails to initialize.
class InitializationErrorApp extends StatelessWidget {
  final String error;
  const InitializationErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 16),
                Text(
                  'initialization_failed'.tr(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'initialization_failed_desc'.tr(),
                  textAlign: TextAlign.center,
                ),
                // Optionally show the error in debug mode
                if (const bool.fromEnvironment("dart.vm.product") == false) ...[
                  const SizedBox(height: 20),
                  Text(
                    '${'error'.tr()}: $error',
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final bool onboardingComplete;

  const MyApp({super.key, required this.onboardingComplete});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, FontSizeProvider>(
      builder: (context, themeProvider, fontSizeProvider, child) {
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
          initialRoute: onboardingComplete ? '/splash' : '/onboarding',
          routes: {
            '/': (context) => const HomePage(),
            '/splash': (context) => const SplashPage(),
            '/settings': (context) => const SettingsPage(),
            '/onboarding': (context) => const OnboardingPage(),
          },
        );
      },
    );
  }
}
