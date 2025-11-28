import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
    _futurePageContent = fetchPageContent();
  }

  Future<String> fetchPageContent() async {
    final ApiService apiService = ApiService();
    return apiService.fetchPageContent(
      languageCode: widget.languageCode,
      title: widget.title,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _pageBuilder.buildDrawer(context),
      bottomNavigationBar: _pageBuilder.buildWikiPageBottomAppBar(
        context,
        widget.title,
      ),
      body: CustomScrollView(
        slivers: [
          _pageBuilder.buildWikiPageAppBar(context, widget.title),
          FutureBuilder<String>(
            future: _futurePageContent,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(child: Text('Error: ${snapshot.error}')),
                );
              }
              if (snapshot.hasData) {
                return SliverToBoxAdapter(
                  child: _pageBuilder.buildBody(
                    context,
                    Future.value(snapshot.data!),
                    PageType.wiki,
                  ),
                );
              }
              return SliverFillRemaining(
                child: Center(child: Text('no_content'.tr())),
              );
            },
          ),
        ],
      ),
    );
  }
}
