import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

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
import 'package:wikikamus/components/share_icon_button.dart';
import 'package:wikikamus/components/view_on_web_icon_button.dart';
import 'package:wikikamus/components/wiktionary_search.dart';
import 'package:wikikamus/pages/content_body.dart';
import 'package:wikikamus/pages/image_page.dart';
import 'package:wikikamus/pages/wiki_page.dart';
import 'package:wikikamus/utils/processed_title.dart';
import 'package:wikikamus/pages/home_page_builders/home_page_builder.dart';

class JavaneseHomePageBuilder implements HomePageBuilder {
  @override
  SliverAppBar buildHomePageAppBar(BuildContext context, String title) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'javanese'.tr(),
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
                  processedTitle(title),
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
  SliverAppBar buildWikiPageAppBar(BuildContext context, String title) {
    final String pageUrl = 'https://jv.m.wiktionary.org/wiki/$title';

    return SliverAppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'Wikikamus Jawa',
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
      RefreshHomeIconButton(),
      RandomIconButton(languageCode: 'jv'),
    ];
    return BottomAppBar(child: Row(children: barChildren));
  }

  @override
  Widget buildWikiPageBottomAppBar(BuildContext context, String title) {
    final List<Widget> barChildren = [
      BottomAppBarLabel(),
      HomeIconButton(),
      RefreshIconButton(languageCode: 'jv', title: title),
      RandomIconButton(languageCode: 'jv'),
    ];
    return BottomAppBar(child: Row(children: barChildren));
  }

  @override
  Widget buildDrawer(BuildContext context) {
    final List<Widget> drawerChildren = [
      DrawerHeaderSection(),
      DrawerCommunityToolsSection(
        languageCode: 'jv',
        mainPageTitle: 'Wikisastra:Pendhapa',
        recentChangesTitle: 'Mirunggan:Owahan anyar',
        randomPageTitle: 'Mirunggan:Kaca_sembarang',
        specialPagesTitle: 'Mirunggan:Kaca_mirunggan',
        communityPortalTitle: 'Wikisastra:Angkringan',
        helpTitle: 'Pitulung:Pambesutan',
        sandboxTitle: 'Wikisastra:Pendhapa',
      ),
      DrawerSettingsSection(),
      DrawerAboutSection(),
    ];
    return Drawer(child: ListView(children: drawerChildren));
  }

  @override
  Widget buildBody(BuildContext context, Future<String> futureContent,
      PageType pageType) {

    void navigateToNewPage(String title) {
      // Navigate to the new page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (context) => WikiPage(languageCode: 'jv', title: title),
        ),
      );
    }

    void navigateToCreatePage(String title) {
      final editUrl =
          'https://jv.m.wiktionary.org/w/index.php?title=$title&action=edit';
      canLaunchUrl(Uri.parse(editUrl)).then((bool result) {
        if (result) {
          launchUrl(Uri.parse(editUrl));
        } else {
          print('Could not launch $editUrl');
        }
      });
    }

    void navigateToImagePage(String imgUrl) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => ImagePage(imagePath: imgUrl),
        ),
      );
    }

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
                  // JavaneseMainHeader(),
                  // const SizedBox(height: 28.0),
                  WiktionarySearch(languageCode: 'jv'),
                  const SizedBox(height: 28.0),
                ],
                ContentBody(
                  html: pageContent,
                  onExistentLinkTap: navigateToNewPage,
                  onNonExistentLinkTap: navigateToCreatePage,
                  onImageLinkTap: navigateToImagePage,
                ),
              ],
            ),
          );
        }
        return Center(child: Text('no_data'.tr()));
      },
    );
  }
}
