import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wikikamus/pages/home_page.dart';
import 'package:wikikamus/pages/onboarding_page.dart';
import 'package:wikikamus/providers/font_size_provider.dart';
import 'package:wikikamus/providers/locale_provider.dart';
import 'package:wikikamus/providers/settings_provider.dart';
import 'package:wikikamus/providers/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _currentLanguageCode;

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  Future<void> _loadCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLanguageCode = prefs.getString('user_language_code');
    });
  }

  Future<void> _selectLanguageAndNavigate(String languageCode) async {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final mainPageTitle = settingsProvider.getMainPageTitleForCode(languageCode);

    final prefs = await SharedPreferences.getInstance();
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr())),
      body: _currentLanguageCode == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Theme mode selection
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'select_appearance'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      // fontFamily: 'Gelasio',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  children: [
                    SegmentedButton<ThemeMode>(
                      segments: [
                        ButtonSegment(
                          value: ThemeMode.light,
                          label: Text('light'.tr()),
                          icon: Icon(Icons.wb_sunny),
                        ),
                        ButtonSegment(
                          value: ThemeMode.system,
                          label: Text('system'.tr()),
                          icon: Icon(Icons.brightness_auto),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          label: Text('dark'.tr()),
                          icon: Icon(Icons.nightlight_round),
                        ),
                      ],
                      selected: {themeProvider.themeMode},
                      onSelectionChanged: (newSelection) {
                        themeProvider.setThemeMode(newSelection.first);
                      },
                    ),
                  ],
                ),
                // Font size selection
                Consumer<FontSizeProvider>(
                  builder: (context, fontSizeProvider, child) {
                    final double baseFontSize = fontSizeProvider.scaledFontSize;
                    return ExpansionTile(
                      initiallyExpanded: true,
                      title: Text(
                        'select_font_size'.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        ListTile(
                          leading: Icon(Icons.text_decrease_outlined),
                          title: Text(
                            'small',
                            style: TextStyle(fontSize: baseFontSize * 0.8),
                          ).tr(),
                          trailing:
                          (fontSizeProvider.currentScale ==
                              FontSizeProvider.fontScales['small'])
                              ? Icon(Icons.done)
                              : null,
                          onTap: () {
                            Navigator.pop(context);
                            fontSizeProvider.setFontSize('small');
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.text_format_outlined),
                          title: Text(
                            'normal',
                            style: TextStyle(fontSize: baseFontSize),
                          ).tr(),
                          trailing:
                          (fontSizeProvider.currentScale ==
                              FontSizeProvider.fontScales['normal'])
                              ? Icon(Icons.done)
                              : null,
                          onTap: () {
                            Navigator.pop(context);
                            fontSizeProvider.setFontSize('normal');
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.text_increase_outlined),
                          title: Text(
                            'large',
                            style: TextStyle(fontSize: baseFontSize * 1.2),
                          ).tr(),
                          trailing:
                          (fontSizeProvider.currentScale ==
                              FontSizeProvider.fontScales['large'])
                              ? Icon(Icons.done)
                              : null,
                          onTap: () {
                            Navigator.pop(context);
                            fontSizeProvider.setFontSize('large');
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.text_increase_outlined),
                          title: Text(
                            'extra_large',
                            style: TextStyle(fontSize: baseFontSize * 1.4),
                          ).tr(),
                          trailing:
                          (fontSizeProvider.currentScale ==
                              FontSizeProvider.fontScales['extra_large'])
                              ? Icon(Icons.done)
                              : null,
                          onTap: () {
                            Navigator.pop(context);
                            fontSizeProvider.setFontSize('extra_large');
                          },
                        ),
                      ],
                    );
                  },
                ),
                // Language selection
                ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    'select_language'.tr(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  children: [
                    // Use a DropdownButton to show the current selection
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 12.0, bottom: 16.0),
                      child: DropdownButtonFormField<String>(
                        initialValue: _currentLanguageCode,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.0,
                          ),
                        ),
                        items: OnboardingPage.supportedLanguages.map((
                          language,
                        ) {
                          return DropdownMenuItem<String>(
                            value: language.code,
                            child: Text(language.name),
                          );
                        }).toList(),
                        onChanged: (String? newLanguageCode) async {
                          if (newLanguageCode != null) {
                            _selectLanguageAndNavigate(newLanguageCode);
                            // await prefs.setString('user_language_code', newLanguageCode)

                            // final prefs = await SharedPreferences.getInstance();
                            //
                            // final newMainPageTitle = settingsProvider.getMainPageTitleForCode(newLanguageCode);

                            // save the values
                            // await prefs.setString('user_language_code', newLanguageCode);
                            // await prefs.setString('user_main_page_title', newMainPageTitle);

                            // update easylocalization for UI text
                            // if (!mounted) return;
                            // context.setLocale(Locale(newLanguageCode));

                            // Force app restart to apply the changes
                            // SystemNavigator.pop();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
