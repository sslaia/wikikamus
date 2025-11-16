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
import 'package:wikikamus/components/nia_main_header.dart';
import 'package:wikikamus/components/open_drawer_button.dart';
import 'package:wikikamus/components/random_icon_button.dart';
import 'package:wikikamus/components/refresh_home_icon_button.dart';
import 'package:wikikamus/components/refresh_icon_button.dart';
import 'package:wikikamus/components/share_icon_button.dart';
import 'package:wikikamus/components/view_on_web_icon_button.dart';
import 'package:wikikamus/components/wiktionary_search.dart';
import 'package:wikikamus/pages/content_body.dart';
import 'package:wikikamus/pages/create_nias_new_entry.dart';
import 'package:wikikamus/pages/image_page.dart';
import 'package:wikikamus/pages/wiki_page.dart';
import 'package:wikikamus/utils/processed_title.dart';
import 'package:wikikamus/pages/home_page_builders/home_page_builder.dart';

class NiasHomePageBuilder implements HomePageBuilder {
  @override
  SliverAppBar buildHomePageAppBar(BuildContext context, String title) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'nias'.tr(),
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
    final String pageUrl = 'https://nia.m.wiktionary.org/wiki/$title';

    return SliverAppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'Wikikamus Nias',
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
                  'assets/images/nias/baluse.webp',
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
      RandomIconButton(languageCode: 'nia'),
    ];
    return BottomAppBar(child: Row(children: barChildren));
  }

  @override
  Widget buildWikiPageBottomAppBar(BuildContext context, String title) {
    final List<Widget> barChildren = [
      BottomAppBarLabel(),
      HomeIconButton(),
      RefreshIconButton(languageCode: 'nia', title: title),
      RandomIconButton(languageCode: 'nia'),
    ];
    return BottomAppBar(child: Row(children: barChildren));
  }

  @override
  Widget buildDrawer(BuildContext context) {
    final List<Widget> drawerChildren = [
      DrawerHeaderSection(),
      DrawerCommunityToolsSection(
        languageCode: 'nia',
        mainPageTitle: 'Wiktionary:Olayama',
        recentChangesTitle: 'Spesial:Perubahan terbaru',
        randomPageTitle: 'Spesial:Halaman sembarang',
        specialPagesTitle: 'Spesial:Halaman istimewa',
        communityPortalTitle: 'Wiktionary:Bawagöli zato',
        helpTitle: 'Fanolo:Fanolo',
        sandboxTitle: 'Wiktionary:Nahia wamakori',
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
    void navigateToNewPage(String title) {
      // Navigate to the new page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (context) => WikiPage(languageCode: 'nia', title: title),
        ),
      );
    }

    void navigateToCreatePage(String title) {
      // Navigate to new entry form
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => CreateNiasNewEntry(title: title),
        ),
      );
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
                  NiasMainHeader(),
                  const SizedBox(height: 28.0),
                  WiktionarySearch(languageCode: 'nia'),
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
            // child: HtmlWidget(
            //   pageContent,
            //   renderMode: RenderMode.column,
            //   buildAsync: true,
            //   textStyle: GoogleFonts.ubuntu(textStyle: Theme.of(context).textTheme.bodyMedium),
            //
            //   /// Customization for mobile display
            //   customStylesBuilder: (element) {
            //     /// Reduce the size of all heading elements
            //     /// as they appear too huge on mobile screens
            //     if (element.localName == 'h1' ||
            //         element.localName == 'h2' ||
            //         element.localName == 'h3') {
            //       return {'font-size': '1.2em'};
            //     }
            //
            //     return null;
            //   },
            //
            //   /// Handling of links
            //   onTapUrl: (url) async {
            //     final uri = Uri.parse(url);
            //
            //     // Handle links that start with "./" (the main page)
            //     if (url.startsWith('./')) {
            //       final title = url.substring(2);
            //
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => WikiPage(
            //             languageCode: 'nia',
            //             title: title,
            //           ),
            //         ),
            //       );
            //       return true;
            //     }
            //
            //     // Handle existent internal wiki links (the wikip age)
            //     if (uri.path.startsWith('/wiki/')) {
            //       final title = uri.pathSegments.last;
            //
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => WikiPage(
            //             languageCode: 'nia',
            //             title: title,
            //           ),
            //         ),
            //       );
            //       return true;
            //     }
            //
            //     // Handle non-existent internal wiki links (the wiki page)
            //     if (uri.path.startsWith('/w/')) {
            //       final title = getLowercaseTitleFromUrl(url);
            //
            //       // temp solution before languageCode is set
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => CreateNiasNewEntry(title: title),
            //         ),
            //       );
            //
            //       /// For Nias Wikionary open the title in create new page form
            //       /// otherwise send the title to external browser for edit
            //       // if (languageCode == 'nia') {
            //       //   Navigator.push(
            //       //     context,
            //       //     MaterialPageRoute(
            //       //       builder: (context) => CreateNiasNewEntry(title: title),
            //       //     ),
            //       //   );
            //       // } else {
            //       //   final editUrl = 'https://$languageCode.m.wiktionary.org/w/index.php?title=$title&action=edit';
            //       //   canLaunchUrl(Uri.parse(url)).then((bool result) {
            //       //     if (result) {
            //       //       launchUrl(Uri.parse(editUrl));
            //       //     } else {
            //       //       print('Could not launch $editUrl');
            //       //     }
            //       //   });
            //       // }
            //
            //       return true;
            //     }
            //
            //     // For all other external links, launch them in a browser
            //     try {
            //       final launchable = await canLaunchUrl(uri);
            //       if (launchable) {
            //         await launchUrl(uri);
            //       } else {
            //         if (context.mounted) {
            //           ScaffoldMessenger.of(context).showSnackBar(
            //             SnackBar(
            //               content: Text('url_launch_error'.tr()),
            //               behavior: SnackBarBehavior.floating,
            //             ),
            //           );
            //         }
            //       }
            //     } catch (e) {
            //       if (context.mounted) {
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           SnackBar(
            //             content: Text('url_launch_error'.tr()),
            //             behavior: SnackBarBehavior.floating,
            //           ),
            //         );
            //       }
            //     }
            //
            //     return true;
            //   },
            //
            //   /// Handling of images
            //   onTapImage: (image) {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => ImagePage(imagePath: image.sources.first.url),
            //       ),
            //     );
            //   },
            //
            // ),
          );
        }
        return Center(child: Text('no_data'.tr()));
      },
    );
  }
}
