import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikikamus/pages/home_page.dart';
import 'package:wikikamus/providers/locale_provider.dart';
import 'package:wikikamus/providers/settings_provider.dart';

class AppLanguage {
  final String code;
  final String name;

  const AppLanguage({required this.code, required this.name});
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  static const List<AppLanguage> supportedLanguages = [
    // AppLanguage(code: 'bew', name: 'Bahasa Betawi'),
    // AppLanguage(code: 'bjn', name: 'Bahasa Banjar'),
    // AppLanguage(code: 'btm', name: 'Bahasa Batak Mandailing'),
    AppLanguage(code: 'en', name: 'English'),
    // AppLanguage(code: 'gor', name: 'Bahasa Gorontalo'),
    AppLanguage(code: 'id', name: 'Bahasa Indonesia'),
    // AppLanguage(code: 'jv', name: 'Bahasa Jawa'),
    // AppLanguage(code: 'mad', name: 'Bahasa Madura'),
    // AppLanguage(code: 'min', name: 'Bahasa Minangkabau'),
    // AppLanguage(code: 'ms', name: 'Bahasa Melayu'),
    AppLanguage(code: 'nia', name: 'Bahasa Nias'),
    // AppLanguage(code: 'su', name: 'Bahasa Sunda'),
  ];

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {

  Future<void> _selectLanguageAndNavigate(String languageCode) async {

    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();

    final mainPageTitle = settingsProvider.getMainPageTitleForCode(languageCode);

    /// Save the new locale to the shared preferences
    await prefs.setString('user_language_code', languageCode);
    await prefs.setString('user_main_page_title', mainPageTitle);
    await prefs.setBool('onboarding_complete', true);

    if (!mounted) return;

    // Update EasyLocalization
    context.setLocale(Locale(languageCode));
    // Notify providers of the new locale
    Provider.of<LocaleProvider>(context, listen: false).setLocale(Locale(languageCode));
    // Navigate to the home page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(languageCode: languageCode, mainPageTitle: mainPageTitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'select_language'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                // Create a button for each supported language
                ...OnboardingPage.supportedLanguages.map(
                  (language) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        _selectLanguageAndNavigate(language.code);
                      },
                      child: Text(language.name),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
