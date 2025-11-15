import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikikamus/pages/home_page.dart';
import 'package:wikikamus/pages/wiki_page.dart';

class DrawerCommunityToolsSection extends StatelessWidget {
  final String languageCode;
  final String mainPageTitle;
  final String recentChangesTitle;
  final String randomPageTitle;
  final String specialPagesTitle;
  final String communityPortalTitle;
  final String helpTitle;
  final String sandboxTitle;

  const DrawerCommunityToolsSection({super.key,
    required this.languageCode,
    required this.mainPageTitle,
    required this.recentChangesTitle,
    required this.randomPageTitle,
    required this.specialPagesTitle,
    required this.communityPortalTitle,
    required this.helpTitle,
    required this.sandboxTitle,
  });

  @override
  Widget build(BuildContext context) {
    final String rcUrl = 'https://$languageCode.wiktionary.org/wiki/Special:RecentChanges';
    final String spUrl = 'https://$languageCode.wiktionary.org/wiki/Special:SpecialPages';
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        'community_tools'.tr(),
        style: GoogleFonts.gelasio(
          textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      children: [
        ListTile(
          leading: Icon(Icons.home_outlined),
          title: Text('main_page'.tr()),
          onTap: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        ListTile(
          leading: Icon(Icons.change_circle_outlined),
          title: Text('recent_changes'.tr()),
          onTap: () {
            Navigator.pop(context);
            launchUrl(Uri.parse(rcUrl));
          },
        ),
        ListTile(
          leading: Icon(Icons.star_outlined),
          title: Text('special_pages'.tr()),
          onTap: () {
            Navigator.pop(context);
            launchUrl(Uri.parse(spUrl));
          },
        ),
        CommunityToolsTile(
          languageCode: languageCode,
          title: communityPortalTitle,
          label: 'community_portal',
          icon: Icon(Icons.groups_outlined),
        ),
        CommunityToolsTile(
          languageCode: languageCode,
          title: helpTitle,
          label: 'help',
          icon: Icon(Icons.help_outline_outlined),
        ),
        CommunityToolsTile(
          languageCode: languageCode,
          title: sandboxTitle,
          label: 'sandbox',
          icon: Icon(Icons.edit_outlined),
        ),
      ],
    );
  }
}

class CommunityToolsTile extends StatelessWidget {
  const CommunityToolsTile({
    super.key,
    required this.languageCode,
    required this.title,
    required this.label,
    required this.icon,
  });

  final String languageCode;
  final String title;
  final String label;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(label.tr()),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => WikiPage(languageCode: languageCode, title: title),
          ),
        );
      },
    );
  }
}
