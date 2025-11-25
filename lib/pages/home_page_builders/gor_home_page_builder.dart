import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wikikamus/components/bottom_app_bar_label.dart';
import 'package:wikikamus/components/drawer_about_section.dart';
import 'package:wikikamus/components/drawer_community_tools_section.dart';
import 'package:wikikamus/components/drawer_header_section.dart';
import 'package:wikikamus/components/drawer_settings_section.dart';
import 'package:wikikamus/components/edit_icon_button.dart';
import 'package:wikikamus/components/home_icon_button.dart';
import 'package:wikikamus/components/open_drawer_button.dart';
import 'package:wikikamus/components/random_icon_button.dart';
import 'package:wikikamus/components/refresh_home_icon_button.dart';
import 'package:wikikamus/components/refresh_icon_button.dart';
import 'package:wikikamus/components/search_and_create_icon_button.dart';
import 'package:wikikamus/components/share_icon_button.dart';
import 'package:wikikamus/components/view_on_web_icon_button.dart';
import 'package:wikikamus/components/wiktionary_search.dart';
import 'package:wikikamus/pages/content_body.dart';
import 'package:wikikamus/pages/home_page_builders/home_page_builder.dart';

class GorontaloHomePageBuilder implements HomePageBuilder {
  @override
  SliverAppBar buildHomePageAppBar(BuildContext context, String title) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'gorontalo'.tr(),
        style: GoogleFonts.cinzelDecorative(
          textStyle: Theme.of(context).textTheme.displayLarge,
          fontWeight: FontWeight.bold,
          letterSpacing: .7,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/images/woman_reading_a_book_on_lap.webp',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  SliverAppBar buildWikiPageAppBar(BuildContext context, String title) {
    final String pageUrl = 'https://gor.m.wiktionary.org/wiki/$title';

    return SliverAppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'Wikikamus Gorontalo',
        style: GoogleFonts.cinzelDecorative(
          textStyle: Theme.of(context).textTheme.titleSmall,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  "assets/images/nias/ni'obutelai.webp",
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  title,
                  style: GoogleFonts.ubuntu(
                    textStyle: Theme.of(context).textTheme.titleSmall,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        ShareIconButton(url: pageUrl),
        EditIconButton(url: '$pageUrl?action=edit&section=all'),
        ViewOnWebIconButton(url: pageUrl),
      ],
    );
  }

  @override
  Widget buildHomePageBottomAppBar(BuildContext context) {
    final List<Widget> barChildren = [
      OpenDrawerButton(),
      BottomAppBarLabel(),
      SearchAndCreateIconButton(languageCode: 'gor'),
      RefreshHomeIconButton(),
      RandomIconButton(languageCode: 'gor'),
    ];
    return BottomAppBar(child: Row(children: barChildren));
  }

  @override
  Widget buildWikiPageBottomAppBar(BuildContext context, String title) {
    final List<Widget> barChildren = [
      BottomAppBarLabel(),
      HomeIconButton(),
      SearchAndCreateIconButton(languageCode: 'gor'),
      RefreshIconButton(languageCode: 'gor', title: title),
      RandomIconButton(languageCode: 'gor'),
    ];
    return BottomAppBar(child: Row(children: barChildren));
  }

  @override
  Widget buildDrawer(BuildContext context) {
    final List<Widget> drawerChildren = [
      DrawerHeaderSection(),
      DrawerCommunityToolsSection(
        languageCode: 'gor',
        mainPageTitle: 'Palepelo',
        recentChangesTitle: "Spesial:BoheliLoboli'aMola",
        randomPageTitle: 'Spesial:Totonula',
        specialPagesTitle: 'Spesial:HalamanSpesial',
        communityPortalTitle: "Wikikamus:Būbu'a lēmbo'a",
        helpTitle: 'Palepelo',
        sandboxTitle: 'Palepelo',
      ),
      DrawerSettingsSection(),
      DrawerAboutSection(),
    ];
    return Drawer(child: ListView(children: drawerChildren));
  }

  @override
  Widget buildBody(
    BuildContext context,
    Future<String> futureContent,
    PageType pageType,
  ) {
    return FutureBuilder<String>(
      future: futureContent,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (snapshot.hasData) {
          final String pageContent = snapshot.data ?? 'no_content'.tr();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (pageType == PageType.home) ...[
                  // GorontaloMainHeader(),
                  // const SizedBox(height: 28.0),
                  WiktionarySearch(languageCode: 'gor'),
                  const SizedBox(height: 28.0),
                ],
                ContentBody(html: pageContent, languageCode: 'gor'),
              ],
            ),
          );
        }
        return Center(child: Text('no_data'.tr()));
      },
    );
  }
}
