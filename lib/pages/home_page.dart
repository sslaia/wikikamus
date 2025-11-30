import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wikikamus/services/api_service.dart';
import 'package:wikikamus/services/cache_service.dart';
import 'package:wikikamus/providers/settings_provider.dart';
import 'package:wikikamus/components/spacer_image.dart';
import 'package:wikikamus/data/footer.dart';
import 'package:wikikamus/pages/home_page_builders/bew_home_page_builder.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final languageCode = settingsProvider.activeLanguageCode;
    final mainPageTitle = settingsProvider.getMainPageTitle();

    final pageBuilder = _getPageBuilder(languageCode);
    final futureMainPageContent = _loadInitialData(languageCode, mainPageTitle);

    final Widget mainBody = CustomScrollView(
      slivers: [
        Builder(
          builder: (context) {
            final orientation = MediaQuery.of(context).orientation;
            return pageBuilder.buildHomePageAppBar(
                context, mainPageTitle, orientation);
          },
        ),        FutureBuilder<String>(
          future: futureMainPageContent,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return SliverFillRemaining(
                child: Center(child: Text('${'error'.tr()}: ${snapshot.error}')),
              );
            }
            if (snapshot.hasData) {
              return SliverToBoxAdapter(
                child: Column(
                  children: [
                    pageBuilder.buildBody(
                      context,
                      Future.value(snapshot.data!),
                      PageType.home,
                    ),
                    const SpacerImage(),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: HtmlWidget(
                        wikikamusFooter,
                        textStyle: const TextStyle(fontSize: 9.0),
                      ),
                    ),
                  ],
                ),
              );
            }
            return SliverFillRemaining(
              child: Center(child: Text('no_content_available.'.tr())),
            );
          },
        ),
      ],
    );

    return OrientationBuilder(
      builder: (context, orientation) {
        final Widget bottomAppBar = pageBuilder.buildHomePageBottomAppBar(
          context,
        );
        return SafeArea(
          child: Scaffold(
            drawer: pageBuilder.buildDrawer(context),
            body: mainBody,
            endDrawer: orientation == Orientation.landscape
                ? bottomAppBar
                : null,
            bottomNavigationBar: orientation == Orientation.portrait
                ? bottomAppBar
                : null,
          ),
        );
      },
    );
  }
}

Future<String> _loadInitialData(String languageCode, String title) async {
  final apiService = ApiService();
  final prefs = await SharedPreferences.getInstance();
  final cacheService = CacheService(prefs, apiService);

  return cacheService.getMainPageContent(
    languageCode: languageCode,
    title: title,
  );
}

HomePageBuilder _getPageBuilder(String languageCode) {
  final builder = {
    'bew': BetawiHomePageBuilder(),
    'bjn': BanjarHomePageBuilder(),
    'btm': BatakMandailingHomePageBuilder(),
    'en': EnglishHomePageBuilder(),
    'gor': GorontaloHomePageBuilder(),
    'id': IndonesianHomePageBuilder(),
    'jv': JavaneseHomePageBuilder(),
    'mad': MadureseHomePageBuilder(),
    'min': MinangkabauHomePageBuilder(),
    'ms': MalayHomePageBuilder(),
    'nia': NiasHomePageBuilder(),
    'su': SundaneseHomePageBuilder(),
  };
  return builder[languageCode] ?? DefaultHomePageBuilder();
}
