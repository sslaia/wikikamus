import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
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

  const DrawerCommunityToolsSection({
    super.key,
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
    final String recentChangesUrl =
        'https://$languageCode.wiktionary.org/wiki/Special:RecentChanges';
    final String specialPagesUrl =
        'https://$languageCode.wiktionary.org/wiki/Special:SpecialPages';

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
          leading: Icon(Icons.change_circle_outlined),
          title: Text('recent_changes'.tr()),
          onTap: () {
            Navigator.pop(context);
            launchUrl(Uri.parse(recentChangesUrl));
          },
        ),
        ListTile(
          leading: Icon(Icons.star_outlined),
          title: Text('special_pages'.tr()),
          onTap: () {
            Navigator.pop(context);
            launchUrl(Uri.parse(specialPagesUrl));
          },
        ),
        ListTile(
          leading: Icon(Icons.groups_outlined),
          title: Text('community_portal'.tr()),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => WikiPage(
                  languageCode: languageCode,
                  title: communityPortalTitle,
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.help_outline_outlined),
          title: Text('help'.tr()),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) =>
                    WikiPage(languageCode: languageCode, title: helpTitle),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.edit_outlined),
          title: Text('sandbox'.tr()),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) =>
                    WikiPage(languageCode: languageCode, title: sandboxTitle),
              ),
            );
          },
        ),
      ],
    );
  }
}
