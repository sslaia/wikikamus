import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wikikamus/components/drawer_about_section.dart';
import 'package:wikikamus/components/drawer_community_tools_section.dart';
import 'package:wikikamus/components/drawer_header_section.dart';
import 'package:wikikamus/components/drawer_settings_section.dart';
import 'package:wikikamus/components/open_drawer_button.dart';
import 'package:wikikamus/components/random_icon_button.dart';
import 'package:wikikamus/components/refresh_home_icon_button.dart';
import 'package:wikikamus/utils/processed_title.dart';
import 'home_page_builder.dart';

class NiasHomePageBuilder implements HomePageBuilder {
  @override
  SliverAppBar buildAppBar(BuildContext context, String title) {
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
                  style: TextStyle(
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
  Widget buildBottomAppBar(BuildContext context) {
    final List<Widget> barChildren = [
      OpenDrawerButton(),
      Text(
        'wiktionary'.tr(),
        style: GoogleFonts.cinzelDecorative(
          textStyle: Theme.of(context).textTheme.displayLarge,
          fontWeight: FontWeight.bold,
          letterSpacing: .7,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      const Spacer(),
      RefreshHomeIconButton(),
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
  Widget buildBody(BuildContext context, Future<String> futureContent) {
    // This is the generic body content structure.
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
            // child: Html(data: snapshot.data),
            child: HtmlWidget(
              pageContent,
              buildAsync: true,
              textStyle: GoogleFonts.ubuntu(
                textStyle: Theme.of(context).textTheme.bodyMedium,
                // fontWeight: FontWeight.bold,
                // letterSpacing: .7,
                // color: Theme.of(context).colorScheme.onPrimary,
              ),

              /// Customization for mobile display
              customStylesBuilder: (element) {
                /// Reduce the size of all heading elements
                /// as they appear too huge
                if (element.localName == 'h1' ||
                    element.localName == 'h2' ||
                    element.localName == 'h3') {
                  return {'font-size': '1.2em'};
                }

                // Adjust blockquotes font size (in amaedola)
                if (element.localName == 'blockquote') {
                  return {'font-size': '1em'};
                }
                return null;
              },

              /// Customization for cards
              // customStylesBuilder: (element) {
              //   if (element.classes.contains('custom-card')) {
              //     return {
              //       'border': '1px solid #a2a9b1',
              //       'border-radius': '4px',
              //       'padding': '1em',
              //       'margin-bottom': '1em',
              //       // Nias-specific highlight color could go here
              //       'background-color': '#f8f9fa',
              //     };
              //   }
            ),
          );
        }
        return Center(child: Text('no_data'.tr()));
      },
    );
  }
}
