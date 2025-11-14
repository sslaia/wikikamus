import 'package:wikikamus/pages/home_page_builders/bjn_home_page_builder.dart';
import 'package:wikikamus/pages/home_page_builders/btm_home_page_builder.dart';
import 'package:wikikamus/pages/home_page_builders/default_home_page_builder.dart';
import 'package:wikikamus/pages/home_page_builders/en_home_page_builder.dart';
import 'package:wikikamus/pages/home_page_builders/gor_home_page_builder.dart';
import 'package:wikikamus/pages/home_page_builders/home_page_builder.dart';
import 'package:wikikamus/pages/home_page_builders/id_home_page_builder.dart';
import 'package:wikikamus/pages/home_page_builders/jv_home_page_builder.dart';
import 'package:wikikamus/pages/home_page_builders/mad_home_page_builder.dart';
import 'package:wikikamus/pages/home_page_builders/min_home_page_builder.dart';
import 'package:wikikamus/pages/home_page_builders/ms_home_page_builder.dart';
import 'package:wikikamus/pages/home_page_builders/nia_home_page_builder.dart';
import 'package:wikikamus/pages/home_page_builders/su_home_page_builder.dart';
import 'package:wikikamus/pages/home_page_builders/bew_home_page_builder.dart';

// A centralized factory to get the correct HomePageBuilder.
class HomePageBuilderFactory {
  // The single source of truth for all UI builders.
  static final Map<String, HomePageBuilder> _pageBuilders = {
    // 'bew': BetawiHomePageBuilder(),
    // 'bjn': BanjarHomePageBuilder(),
    // 'btm': BatakMandailingHomePageBuilder(),
    'en': EnglishHomePageBuilder(),
    // 'gor': GorontaloHomePageBuilder(),
    'id': IndonesianHomePageBuilder(),
    // 'jv': JavaneseHomePageBuilder(),
    // 'mad': MadureseHomePageBuilder(),
    // 'min': MinangkabauHomePageBuilder(),
    // 'ms': MalayHomePageBuilder(),
    'nia': NiasHomePageBuilder(),
    // 'su': SundaneseHomePageBuilder(),
  };

  // A static method to get the builder for a given language code.
  // It falls back to DefaultHomePageBuilder if the requested language is not found.
  static HomePageBuilder getBuilder(String languageCode) {
    return _pageBuilders[languageCode] ?? DefaultHomePageBuilder();
  }
}
