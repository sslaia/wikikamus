import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wikikamus/components/bottom_app_bar_label.dart';
import 'package:wikikamus/components/create_page_icon_button.dart';
import 'package:wikikamus/components/drawer_about_section.dart';
import 'package:wikikamus/components/drawer_community_tools_section.dart';
import 'package:wikikamus/components/drawer_header_section.dart';
import 'package:wikikamus/components/drawer_settings_section.dart';
import 'package:wikikamus/components/edit_icon_button.dart';
import 'package:wikikamus/components/home_icon_button.dart';
import 'package:wikikamus/components/main_header.dart';
import 'package:wikikamus/components/open_drawer_button.dart';
import 'package:wikikamus/components/random_icon_button.dart';
import 'package:wikikamus/components/refresh_home_icon_button.dart';
import 'package:wikikamus/components/refresh_icon_button.dart';
import 'package:wikikamus/components/search_icon_button.dart';
import 'package:wikikamus/components/share_icon_button.dart';
import 'package:wikikamus/components/spacer_color_bar.dart';
import 'package:wikikamus/components/view_on_web_icon_button.dart';
import 'package:wikikamus/components/wiki_bottom_app_bar.dart';
import 'package:wikikamus/components/wiktionary_search.dart';
import 'package:wikikamus/pages/content_body.dart';
import 'package:wikikamus/pages/create_nias_new_entry.dart';
import 'package:wikikamus/utils/processed_title.dart';
import 'package:wikikamus/pages/home_page_builders/home_page_builder.dart';

class NiasHomePageBuilder implements HomePageBuilder {
  @override
  SliverAppBar buildHomePageAppBar(
    BuildContext context,
    String title,
    Orientation orientation,
  ) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'Wikikamus li Niha',
        style: GoogleFonts.cinzelDecorative(
          textStyle: Theme.of(context).textTheme.displayLarge,
          fontWeight: FontWeight.bold,
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
                  'assets/images/nias/anak-sekolah.webp',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  processedTitle(title.replaceAll('_', ' ')),
                  style: GoogleFonts.ubuntuSans(
                    textStyle: Theme.of(context).textTheme.titleSmall,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (orientation == Orientation.landscape)
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              color: Theme.of(context).colorScheme.onPrimary,
              tooltip: 'open_menu'.tr(),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
      ],
    );
  }

  @override
  SliverAppBar buildWikiPageAppBar(
    BuildContext context,
    String title,
    Orientation orientation,
  ) {
    final String pageUrl = 'https://nia.m.wiktionary.org/wiki/$title';

    return SliverAppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'Li Niha',
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
                  fit: BoxFit.fitHeight,
                  height: 200,
                ),
              ),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  processedTitle(title.replaceAll('_', ' ')),
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
        if (orientation == Orientation.landscape)
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              tooltip: 'open_menu'.tr(),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
      ],
    );
  }

  @override
  Widget buildHomePageBottomAppBar(BuildContext context) {
    final List<Widget> barChildren = [
      OpenDrawerButton(),
      if (MediaQuery.of(context).orientation == Orientation.landscape) Spacer(),
      if (MediaQuery.of(context).orientation == Orientation.portrait)
        BottomAppBarLabel(),
      if (MediaQuery.of(context).orientation == Orientation.portrait)
        CreatePageIconButton(destination: CreateNiasNewEntry()),
      // SearchAndCreateIconButton(languageCode: 'nia'),
      RefreshHomeIconButton(),
      RandomIconButton(languageCode: 'nia'),
    ];
    return WikiBottomAppBar(children: barChildren);
  }

  @override
  Widget buildWikiPageBottomAppBar(BuildContext context, String title) {
    final List<Widget> barChildren = [
      if (MediaQuery.of(context).orientation == Orientation.portrait)
        BottomAppBarLabel(),
      if (MediaQuery.of(context).orientation == Orientation.landscape) Spacer(),
      HomeIconButton(),
      if (MediaQuery.of(context).orientation == Orientation.portrait)
        SearchIconButton(languageCode: 'nia'),
      RefreshIconButton(languageCode: 'nia', title: title),
      RandomIconButton(languageCode: 'nia'),
    ];
    return WikiBottomAppBar(children: barChildren);
  }

  @override
  Widget buildDrawer(BuildContext context) {
    final List<Widget> drawerChildren = [
      DrawerHeaderSection(),
      DrawerCommunityToolsSection(
        languageCode: 'nia',
        mainPageTitle: 'Wikikamus:Olayama',
        recentChangesTitle: 'Spesial:Perubahan terbaru',
        randomPageTitle: 'Spesial:Halaman sembarang',
        specialPagesTitle: 'Spesial:Halaman istimewa',
        communityPortalTitle: 'Wikikamus:Bawagöli zato',
        helpTitle: 'Fanolo:Fanolo',
        sandboxTitle: 'Wikikamus:Nahia wamakori',
      ),
      DrawerSettingsSection(),
      DrawerAboutSection(),
      // DrawerAuthSection(),
    ];
    return Drawer(child: ListView(children: drawerChildren));
  }

  @override
  Widget buildBody(
    BuildContext context,
    String pageContent,
    PageType pageType,
  ) {
    void navigateToCreatePage(String title) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => CreateNiasNewEntry(title: title),
        ),
      );
    }

    return Column(
      children: [
        if (pageType == PageType.home) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                MainHeader(language: 'Nias'),
                const SizedBox(height: 28.0),
                WiktionarySearch(languageCode: 'nia'),
                const SizedBox(height: 28.0),
                SpacerColorBar(imageWidth: double.infinity),
              ],
            ),
          ),
        ],
        ContentBody(
          html: pageContent,
          languageCode: 'nia',
          onCreatePageTap: (String title) {
            navigateToCreatePage(title);
          },
        ),
      ],
    );
  }
}
