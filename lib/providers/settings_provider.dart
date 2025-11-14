import 'package:flutter/material.dart';
import 'package:wikikamus/providers/locale_provider.dart';

class SettingsProvider with ChangeNotifier {
  late String _activeLanguageCode;
  final LocaleProvider _localeProvider;

  SettingsProvider(this._localeProvider) {
    _activeLanguageCode = _localeProvider.locale.languageCode;

    _localeProvider.addListener(_onLocaleChange);
  }

  void _onLocaleChange() {
    if (_activeLanguageCode != _localeProvider.locale.languageCode) {
      _activeLanguageCode = _localeProvider.locale.languageCode;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _localeProvider.removeListener(_onLocaleChange);
    super.dispose();
  }

  final Map<String, String> _mainPageTitles = {
    // "bew": "",
    // "bjn": "",
    // "btm": ",
    "en": "Wiktionary:Main Page",
    // "gor": "",
    "id": "Wikikamus:Halaman Utama",
    // "jv": "",
    // "mad": "",
    // "min": "",
    // "ms": "",
    "nia": "Wiktionary:Olayama",
    // "su": "",
  };

  final Map<String, String> _recentChangesTitles = {
    // "bew": "",
    // "bjn": "",
    // "btm": ",
    "en": "Special:RecentChanges",
    // "gor": "",
    "id": "Istimewa:Perubahan terbaru",
    // "jv": "",
    // "mad": "",
    // "min": "",
    // "ms": "",
    "nia": "Spesial:Perubahan terbaru",
    // "su": "",
  };

  final Map<String, String> _randomPageTitles = {
    // "bew": "",
    // "bjn": "",
    // "btm": ",
    "en": "Special:Random",
    // "gor": "",
    "id": "Istimewa:Halaman sembarang",
    // "jv": "",
    // "mad": "",
    // "min": "",
    // "ms": "",
    "nia": "Spesial:Halaman sembarang",
    // "su": "",
  };

  final Map<String, String> _specialPagesTitles = {
    // "bew": "",
    // "bjn": "",
    // "btm": ",
    "en": "Special:SpecialPages",
    // "gor": "",
    "id": "Istimewa:Halaman istimewa",
    // "jv": "",
    // "mad": "",
    // "min": "",
    // "ms": "",
    "nia": "Spesial:Halaman istimewa",
    // "su": "",
  };

  final Map<String, String> _communityPortalTitles = {
    // "bew": "",
    // "bjn": "",
    // "btm": ",
    "en": "Wiktionary:Community portal",
    // "gor": "",
    "id": "Wikikamus:Warung Kopi",
    // "jv": "",
    // "mad": "",
    // "min": "",
    // "ms": "",
    "nia": "Wiktionary:Bawagöli zato",
    // "su": "",
  };

  final Map<String, String> _helpTitles = {
    // "bew": "",
    // "bjn": "",
    // "btm": ",
    "en": "Help:Contents",
    // "gor": "",
    "id": "Bantuan:Isi",
    // "jv": "",
    // "mad": "",
    // "min": "",
    // "ms": "",
    "nia": "Fanolo:Fanolo",
    // "su": "",
  };

  final Map<String, String> _sandboxTitles = {
    // "bew": "",
    // "bjn": "",
    // "btm": ",
    "en": "Wiktionary:Sandbox",
    // "gor": "",
    "id": "Wikikamus:Bak pasir",
    // "jv": "",
    // "mad": "",
    // "min": "",
    // "ms": "",
    "nia": "Wiktionary:Nahia wamakori",
    // "su": "",
  };

  String get activeLanguageCode => _activeLanguageCode;

  void setActiveLanguageCode(String code) {
    _activeLanguageCode = code;
    notifyListeners();
  }

  // Get the titles for the active language
  String getMainPageTitle() {
    return _mainPageTitles[_activeLanguageCode] ?? _mainPageTitles['id']!;
  }

  String getMainPageTitleForCode(String languageCode) {
    return _mainPageTitles[languageCode] ?? _mainPageTitles['id']!;
  }

  String getRecentChangesTitle() {
    return _recentChangesTitles[_activeLanguageCode] ?? _recentChangesTitles['id']!;
  }

  String getRandomPageTitle() {
    return _randomPageTitles[_activeLanguageCode] ?? _randomPageTitles['id']!;
  }

  String getSpecialPagesTitle() {
    return _specialPagesTitles[_activeLanguageCode] ?? _specialPagesTitles['id']!;
  }

  String getCommunityPortalTitle() {
    return _communityPortalTitles[_activeLanguageCode] ?? _communityPortalTitles['id']!;
  }

  String getHelpTitle() {
    return _helpTitles[_activeLanguageCode] ?? _helpTitles['id']!;
  }

  String getSandboxTitle() {
    return _sandboxTitles[_activeLanguageCode] ?? _sandboxTitles['id']!;
  }
}
