import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wikikamus/pages/home_page.dart';
import 'package:wikikamus/providers/font_size_provider.dart';
import 'package:wikikamus/providers/settings_provider.dart';
import 'package:wikikamus/providers/theme_provider.dart';

class Language {
  final String name;
  final String code;

  const Language({required this.name, required this.code});
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static const List<Language> supportedLanguages = [
    Language(code: 'bew', name: 'Bahasa Betawi'),
    Language(code: 'bjn', name: 'Bahasa Banjar'),
    Language(code: 'btm', name: 'Bahasa Batak Mandailing'),
    Language(code: 'en', name: 'English'),
    Language(code: 'gor', name: 'Bahasa Gorontalo'),
    Language(code: 'id', name: 'Bahasa Indonesia'),
    Language(code: 'jv', name: 'Bahasa Jawa'),
    Language(code: 'mad', name: 'Bahasa Madura'),
    Language(code: 'min', name: 'Bahasa Minangkabau'),
    Language(code: 'ms', name: 'Bahasa Melayu'),
    Language(code: 'nia', name: 'Bahasa Nias'),
    Language(code: 'su', name: 'Bahasa Sunda'),
  ];

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectLanguageAndNavigate(String languageCode) async {
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );
    settingsProvider.setLanguage(languageCode);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);

    if (!mounted) return;
    await context.setLocale(Locale(languageCode));
    
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final String currentLanguageCode = settingsProvider.activeLanguageCode;

    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr())),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Theme mode selection
            ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                'select_appearance'.tr(),
                style: GoogleFonts.gelasio(
                  textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: SegmentedButton<ThemeMode>(
                    segments: [
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('light'.tr()),
                        icon: const Icon(Icons.wb_sunny),
                      ),
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('system'.tr()),
                        icon: const Icon(Icons.brightness_auto),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text('dark'.tr()),
                        icon: const Icon(Icons.nightlight_round),
                      ),
                    ],
                    selected: {themeProvider.themeMode},
                    onSelectionChanged: (newSelection) {
                      themeProvider.setThemeMode(newSelection.first);
                    },
                  ),
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
                    style: GoogleFonts.gelasio(
                      textStyle:
                      Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.text_decrease_outlined),
                      title: Text(
                        'small',
                        style: TextStyle(fontSize: baseFontSize * 0.8),
                      ).tr(),
                      trailing: (fontSizeProvider.currentScale ==
                          FontSizeProvider.fontScales['small'])
                          ? const Icon(Icons.done)
                          : null,
                      onTap: () {
                        fontSizeProvider.setFontSize('small');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.text_format_outlined),
                      title: Text(
                        'normal',
                        style: TextStyle(fontSize: baseFontSize),
                      ).tr(),
                      trailing: (fontSizeProvider.currentScale ==
                          FontSizeProvider.fontScales['normal'])
                          ? const Icon(Icons.done)
                          : null,
                      onTap: () {
                        fontSizeProvider.setFontSize('normal');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.text_increase_outlined),
                      title: Text(
                        'large',
                        style: TextStyle(fontSize: baseFontSize * 1.2),
                      ).tr(),
                      trailing: (fontSizeProvider.currentScale ==
                          FontSizeProvider.fontScales['large'])
                          ? const Icon(Icons.done)
                          : null,
                      onTap: () {
                        fontSizeProvider.setFontSize('large');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.text_increase_outlined),
                      title: Text(
                        'extra_large',
                        style: TextStyle(fontSize: baseFontSize * 1.4),
                      ).tr(),
                      trailing: (fontSizeProvider.currentScale ==
                          FontSizeProvider.fontScales['extra_large'])
                          ? const Icon(Icons.done)
                          : null,
                      onTap: () {
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
                style: GoogleFonts.gelasio(
                  textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 12.0,
                    bottom: 16.0,
                    top: 8.0,
                  ),
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: currentLanguageCode,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.0,
                      ),
                    ),
                    // Use the new, more appropriate list
                    items: SettingsPage.supportedLanguages.map((
                        language,
                        ) {
                      return DropdownMenuItem<String>(
                        value: language.code,
                        child: Text(
                          language.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newLanguageCode) async {
                      if (newLanguageCode != null) {
                          _selectLanguageAndNavigate(newLanguageCode);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
