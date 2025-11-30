import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wikikamus/components/bottom_app_bar_label.dart';
import 'package:wikikamus/components/drawer_about_section.dart';
import 'package:wikikamus/components/drawer_community_tools_section.dart';
import 'package:wikikamus/components/drawer_header_section.dart';
import 'package:wikikamus/components/drawer_settings_section.dart';
import 'package:wikikamus/components/edit_icon_button.dart';
import 'package:wikikamus/components/en_main_header.dart';
import 'package:wikikamus/components/home_icon_button.dart';
import 'package:wikikamus/components/open_drawer_button.dart';
import 'package:wikikamus/components/random_icon_button.dart';
import 'package:wikikamus/components/refresh_home_icon_button.dart';
import 'package:wikikamus/components/refresh_icon_button.dart';
import 'package:wikikamus/components/search_and_create_icon_button.dart';
import 'package:wikikamus/components/share_icon_button.dart';
import 'package:wikikamus/components/view_on_web_icon_button.dart';
import 'package:wikikamus/pages/content_body.dart';
import 'package:wikikamus/utils/processed_title.dart';
import 'package:wikikamus/pages/home_page_builders/home_page_builder.dart';

class EnglishHomePageBuilder implements HomePageBuilder {
  @override
  SliverAppBar buildHomePageAppBar(BuildContext context, String title, Orientation orientation) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'English Wiktionary',
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
    );
  }

  @override
  SliverAppBar buildWikiPageAppBar(BuildContext context, String title, Orientation orientation) {
    final String pageUrl = 'https://en.m.wiktionary.org/wiki/$title';

    return SliverAppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'English',
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
      ],
    );
  }

  @override
  Widget buildHomePageBottomAppBar(BuildContext context) {
    final List<Widget> barChildren = [
      OpenDrawerButton(),
      BottomAppBarLabel(),
      SearchAndCreateIconButton(languageCode: 'en'),
      RefreshHomeIconButton(),
      RandomIconButton(languageCode: 'en'),
    ];
    return BottomAppBar(child: Row(children: barChildren));
  }

  @override
  Widget buildWikiPageBottomAppBar(BuildContext context, String title) {
    final List<Widget> barChildren = [
      BottomAppBarLabel(),
      HomeIconButton(),
      SearchAndCreateIconButton(languageCode: 'en'),
      RefreshIconButton(languageCode: 'en', title: title),
      RandomIconButton(languageCode: 'en'),
    ];
    return BottomAppBar(child: Row(children: barChildren));
  }

  @override
  Widget buildDrawer(BuildContext context) {
    final List<Widget> drawerChildren = [
      DrawerHeaderSection(),
      DrawerCommunityToolsSection(
        languageCode: 'en',
        mainPageTitle: 'Wiktionary:Main Page',
        recentChangesTitle: 'Special:RecentChanges',
        randomPageTitle: 'Special:Random',
        specialPagesTitle: 'Special:SpecialPages',
        communityPortalTitle: 'Wiktionary:Community Portal',
        helpTitle: 'Help:Contents',
        sandboxTitle: 'Wiktionary:Sandbox',
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

          return Column(
            children: [
              if (pageType == PageType.home) ...[
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        EnglishMainHeader(),
                        const SizedBox(height: 28.0),
                      ],
                    ))
              ],
              ContentBody(html: pageContent, languageCode: 'en'),
            ],
          );
        }
        return Center(child: Text('no_data'.tr()));
      },
    );
  }
}
