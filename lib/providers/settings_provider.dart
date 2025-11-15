import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  String _activeLanguageCode = 'id';
  String _mainPageTitle = 'Halaman_Utama';

  String get activeLanguageCode => _activeLanguageCode;
  String get mainPageTitle => _mainPageTitle;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _activeLanguageCode = prefs.getString('user_language_code') ?? 'id';
    _mainPageTitle = prefs.getString('user_main_page_title') ?? 'Halaman_Utama';
  }

  Future<void> updateLanguage(String newLanguageCode, BuildContext context) async {
    // Update internal state
    _activeLanguageCode = newLanguageCode;
    _mainPageTitle = getMainPageTitleForCode(newLanguageCode);

    // Persist the state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_language_code', _activeLanguageCode);
    await prefs.setString('user_main_page_title', _mainPageTitle);

    // Update EasyLocalization
    await context.setLocale(Locale(_activeLanguageCode));

    notifyListeners();
  }

  void setActiveLanguageCode(String code) {
    _activeLanguageCode = code;
    notifyListeners();
  }

  final Map<String, String> _mainPageTitles = {
    "bew": "Wikikamus:Balé-balé",
    "bjn": "Laman_Tatambaian",
    "btm": "Wikikamus:Alaman Utamo",
    "en": "Wiktionary:Main Page",
    "gor": "Palepelo",
    "id": "Wikikamus:Halaman Utama",
    "jv": "Wikisastra:Pendhapa",
    "mad": "Wikikamus:Tanèyan",
    "min": "Laman Utamo",
    "ms": "Wikikamus:Laman Utama",
    "nia": "Wiktionary:Olayama",
    "su": "Tepas",
  };

  final Map<String, String> _recentChangesTitles = {
    "bew": "Istimèwa:Perubahan terbaru",
    "bjn": "Istimiwa:Paubahan pahanyarnya",
    "btm": "Husus:Perubahan terbaru",
    "en": "Special:RecentChanges",
    "gor": "Spesial:BoheliLoboli'aMola",
    "id": "Istimewa:Perubahan terbaru",
    "jv": "Mirunggan:Owahan anyar",
    "mad": "Spesial:Perubahan terbaru",
    "min": "Istimewa:ParubahanBaru",
    "ms": "Khas:Perubahan terkini",
    "nia": "Spesial:Perubahan terbaru",
    "su": "Husus:AnyarRobah",
  };

  final Map<String, String> _randomPageTitles = {
    "bew": "Istimèwa:Halaman sembarang",
    "bjn": "Istimiwa:Tungkaran babarang",
    "btm": "Husus:Halaman sembarang",
    "en": "Special:Random",
    "gor": "Spesial:Totonula",
    "id": "Istimewa:Halaman sembarang",
    "jv": "Mirunggan:Kaca_sembarang",
    "mad": "Spesial:Halaman sembarang",
    "min": "Istimewa:LamanSumbarang",
    "ms": "Khas:Rawak",
    "nia": "Spesial:Halaman sembarang",
    "su": "Husus:Acak",
  };

  final Map<String, String> _specialPagesTitles = {
    "bew": "Istimèwa:Halaman istimewa",
    "bjn": "Istimiwa:Tungkaran istimiwa",
    "btm": "Husus:Halaman istimewa",
    "en": "Special:SpecialPages",
    "gor": "Spesial:HalamanSpesial",
    "id": "Istimewa:Halaman istimewa",
    "jv": "Mirunggan:Kaca_mirunggan",
    "mad": "Spesial:Halaman istimewa",
    "min": "Istimewa:LamanIstimewa",
    "ms": "Khas:Laman khas",
    "nia": "Spesial:Halaman istimewa",
    "su": "Husus:KacaHusus",
  };

  final Map<String, String> _communityPortalTitles = {
    "bew": "Wikikamus:Balé-balé",
    "bjn": "Wikikamus:Warung Kupi",
    "btm": "Wikikamus:Portal komunitas",
    "en": "Wiktionary:Community portal",
    "gor": "Wikikamus:Būbu'a lēmbo'a",
    "id": "Wikikamus:Warung Kopi",
    "jv": "Wikisastra:Angkringan",
    "mad": "Wikikamus:Bârung Kopi",
    "min": "Wikikato:Portal komunitas",
    "ms": "Wikikamus:Gerbang komuniti",
    "nia": "Wiktionary:Bawagöli zato",
    "su": "Wiktionary:Sawala",
  };

  final Map<String, String> _helpTitles = {
    "bew": "Wikikamus:Balé-balé",
    "bjn": "Wikikamus:Warung Kupi",
    "btm": "Wikikamus:Alaman Utamo",
    "en": "Help:Contents",
    "gor": "Palepelo",
    "id": "Bantuan:Isi",
    "jv": "Pitulung:Pambesutan",
    "mad": "Bhântowan:Èssè",
    "min": "Wikikato:Portal komunitas",
    "ms": "Bantuan:Kandungan",
    "nia": "Fanolo:Fanolo",
    "su": "Pitulung:Eusi",
  };

  final Map<String, String> _sandboxTitles = {
    "bew": "Wikikamus:Balé-balé",
    "bjn": "Wikikamus:Warung Kupi",
    "btm": "Wikikamus:Alaman Utamo",
    "en": "Wiktionary:Sandbox",
    "gor": "Palepelo",
    "id": "Wikikamus:Bak pasir",
    "jv": "Wikisastra:Pendhapa",
    "mad": "Bhântowan:Èssè",
    "min": "Wikikato:Portal komunitas",
    "ms": "Wikikamus:Kotak pasir",
    "nia": "Wiktionary:Nahia wamakori",
    "su": "Wiktionary:Kotrétan",
  };

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
