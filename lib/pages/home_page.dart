import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikikamus/components/open_drawer_button.dart';
import 'package:wikikamus/components/random_icon_button.dart';
import 'package:wikikamus/components/refresh_home_icon_button.dart';
import 'package:wikikamus/components/spacer_image.dart';
import 'package:wikikamus/components/wiktionary_search.dart';
import 'package:wikikamus/data/footer.dart';
import 'package:wikikamus/pages/home_page_builders/default_home_page_builder.dart';

import 'package:wikikamus/pages/home_page_builders/en_home_page_builder.dart';
import 'package:wikikamus/pages/home_page_builders/home_page_builder.dart';
import 'package:wikikamus/pages/home_page_builders/id_home_page_builder.dart';
import 'package:wikikamus/pages/home_page_builders/nia_home_page_builder.dart';
import 'package:wikikamus/services/api_service.dart';
import 'package:wikikamus/services/cache_service.dart';

class HomePage extends StatefulWidget {
  final String languageCode;
  final String mainPageTitle;

  const HomePage({
    super.key,
    required this.languageCode,
    required this.mainPageTitle,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String> _futureMainPageContent;
  late HomePageBuilder _pageBuilder;

  @override
  void initState() {
    super.initState();
    _pageBuilder = _getPageBuilder(widget.languageCode);
    _futureMainPageContent = _loadInitialData();
  }

  Future<String> _loadInitialData() async {
    final apiService = ApiService();
    final prefs = await SharedPreferences.getInstance();
    final cacheService = CacheService(prefs, apiService);

    return cacheService.getMainPageContent(
      languageCode: widget.languageCode,
      title: widget.mainPageTitle,
    );
  }

  HomePageBuilder _getPageBuilder(String languageCode) {
    final builder = {
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
      // 'su': SundaneseHomePageBuilder()
    };
    return builder[languageCode] ?? DefaultHomePageBuilder();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> barChildren = [
      OpenDrawerButton(),
      Expanded(
        child: Text(
          'wiktionary'.tr(),
          textAlign: TextAlign.left,
          style: GoogleFonts.cinzelDecorative(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontWeight: FontWeight.bold,
            letterSpacing: .7,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      RefreshHomeIconButton(),
      RandomIconButton(languageCode: widget.languageCode),
    ];

    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: _pageBuilder.buildDrawer(context),
      bottomNavigationBar: BuildBottomAppBar(barChildren: barChildren),
      body: CustomScrollView(
        slivers: [
          _pageBuilder.buildAppBar(context, widget.mainPageTitle),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: WiktionarySearch(languageCode: widget.languageCode),
                ),
                FutureBuilder<String>(
                  future: _futureMainPageContent,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        heightFactor: 10,
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.hasData) {
                      return _pageBuilder.buildBody(
                        context,
                        Future.value(snapshot.data!),
                      );
                    }
                    return const Center(child: Text('No content available.'));
                  },
                ),
                const SpacerImage(),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: HtmlWidget(wikikamusFooter, textStyle: TextStyle(fontSize: 9.0)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BuildBottomAppBar extends StatelessWidget {
  const BuildBottomAppBar({super.key, required this.barChildren});

  final List<Widget> barChildren;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: barChildren,
      ),
    );
  }
}
