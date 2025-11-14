import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wikikamus/components/home_icon_button.dart';
import 'package:wikikamus/components/random_icon_button.dart';
import 'package:wikikamus/components/refresh_icon_button.dart';
import 'package:wikikamus/pages/home_page_builders/default_home_page_builder.dart';

import 'package:wikikamus/pages/home_page_builders/en_home_page_builder.dart';
import 'package:wikikamus/pages/home_page_builders/home_page_builder.dart';
import 'package:wikikamus/pages/home_page_builders/id_home_page_builder.dart';
import 'package:wikikamus/pages/home_page_builders/nia_home_page_builder.dart';
import 'package:wikikamus/services/api_service.dart';

class WikiPage extends StatefulWidget {
  final String languageCode;
  final String title;

  const WikiPage({super.key, required this.languageCode, required this.title});

  @override
  State<WikiPage> createState() => _WikiPageState();
}

class _WikiPageState extends State<WikiPage> {
  late Future<String> _futurePageContent;
  late HomePageBuilder _pageBuilder;

  @override
  void initState() {
    super.initState();
    _pageBuilder = _getPageBuilder(widget.languageCode);
    fetchPageContent();
  }

  void fetchPageContent() async {
    final ApiService apiService = ApiService();
    _futurePageContent = apiService.fetchPageContent(
      languageCode: widget.languageCode,
      title: widget.title,
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
      // OpenDrawerButton(),
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
      HomeIconButton(),
      RefreshIconButton(languageCode: widget.languageCode, title: widget.title),
      RandomIconButton(languageCode: widget.languageCode),
    ];

    return Scaffold(
      drawer: _pageBuilder.buildDrawer(context),
      bottomNavigationBar: BuildBottomAppBar(barChildren: barChildren),
      body: CustomScrollView(
        slivers: [
          _pageBuilder.buildAppBar(context, widget.title),
          SliverToBoxAdapter(
            child: FutureBuilder<String>(
              future: _futurePageContent,
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
                return Center(child: Text('no_content').tr());
              },
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
