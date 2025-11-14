import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:wikikamus/components/drawer_about_section.dart';
import 'package:wikikamus/components/drawer_community_tools_section.dart';
import 'package:wikikamus/components/drawer_header_section.dart';
import 'package:wikikamus/components/drawer_settings_section.dart';
import 'package:wikikamus/pages/settings_page.dart';
import 'home_page_builder.dart';

// This class builds a generic, un-styled UI.
class DefaultHomePageBuilder implements HomePageBuilder {
  @override
  SliverAppBar buildAppBar(BuildContext context, String title) {
    return SliverAppBar(
      title: const Text('Wiktionary'),
      floating: true,
      snap: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (context) => SettingsPage()),
            );
          },
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
    );
  }

  @override
  Widget buildBottomAppBar(BuildContext context) {
    // TODO: implement buildBottomAppBar
    throw UnimplementedError();
  }

  @override
  Widget buildDrawer(BuildContext context) {
    final List<Widget> drawerChildren = [
      DrawerHeaderSection(),
      DrawerCommunityToolsSection(
        languageCode: '',
        mainPageTitle: 'Wiktionary:Main Page',
        recentChangesTitle: 'Special:',
        randomPageTitle: 'Special:',
        specialPagesTitle: 'Spesial:Halaman istimewa',
        communityPortalTitle: 'Wiktionary:',
        helpTitle: 'Bantuan',
        sandboxTitle: 'Wiktionary:',
      ),
      DrawerSettingsSection(),
      DrawerAboutSection(),
    ];
    return Drawer(child: ListView(children: drawerChildren));
  }

  @override
  Widget buildBody(BuildContext context, Future<String> futureContent) {
    // The same body logic as the Nias one, but could have simpler styling.
    return FutureBuilder<String>(
      future: futureContent,
      builder: (context, snapshot) {
        // ... (builder logic is identical to Nias for now)
        // In the future, you might have simpler or no custom styling here.
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: HtmlWidget(snapshot.data ?? ''),
          );
        }
        // ... other states
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

}
