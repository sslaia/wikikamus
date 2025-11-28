import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:wikikamus/pages/image_page.dart';
import 'package:wikikamus/pages/wiki_page.dart';
import 'package:wikikamus/utils/get_lowercase_title_from_url.dart';

class ContentBody extends StatelessWidget {
  const ContentBody({
    super.key,
    required this.html,
    required this.languageCode,
    this.onCreatePageTap,
  });

  final String html;
  final String languageCode;
  final void Function(String title)? onCreatePageTap;

  /// Selects the appropriate font based on the language code.
  TextStyle _getFontForLanguage(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.bodyMedium;
    switch (languageCode) {
      case 'jv': // Javanese
        return GoogleFonts.notoSansJavanese(textStyle: baseStyle);
      case 'su': // Sundanese
        return GoogleFonts.notoSansSundanese(textStyle: baseStyle);
      // Add other languages with specific fonts here
      default:
        return GoogleFonts.nunitoSans(textStyle: baseStyle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: HtmlWidget(
        html,
        buildAsync: true,
        renderMode: RenderMode.column,
        textStyle: _getFontForLanguage(context),

        /// Customization for mobile display
        customStylesBuilder: (element) {
          // Reduce the size of all heading elements that appear too huge on mobile screens
          if (element.localName == 'h1' ||
              element.localName == 'h2' ||
              element.localName == 'h3') {
            return {'font-size': '1.2em'};
          }
          return null;
        },


        /// Handling of links
        onTapUrl: (url) async {
          final uri = Uri.parse(url);
          final titleFromPath = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
          // List of Special namespace in different languages. Needs to add for Javanese, Banjar, Madurese, etc.
          final specialNamespaces = ['Special:', 'Spesial:', 'Istimewa:'];
          final isSpecialLink = specialNamespaces.any((ns) => titleFromPath.startsWith(ns));

          // Handle Special links
          if (isSpecialLink) {
            final fullUrl = 'https://$languageCode.m.wiktionary.org/wiki/$titleFromPath';
            final launchUri = Uri.parse(fullUrl);
            if (await canLaunchUrl(launchUri)) {
              await launchUrl(launchUri, mode: LaunchMode.externalApplication);
            }
            return true;
          }

          // Handle links that start with "./" (the main page)
          // if (url.startsWith('./')) {
          //   final title = url.substring(2);
          //   onExistentLinkTap(title);
          //   return true;
          // }

          // Handle existent internal wiki links
          if (uri.path.startsWith('/wiki/') || url.startsWith('./')) {
            final title = url.startsWith('./') ? url.substring(2) : uri.pathSegments.last;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WikiPage(languageCode: languageCode, title: title),
              ),
            );
            return true;
          }

          // Handle non-existent internal wiki links (the wiki page)
          if (uri.path.startsWith('/w/')) {
            final title = getLowercaseTitleFromUrl(url);
            final createCallback = onCreatePageTap;
            if (createCallback != null) {
              createCallback(title);
            } else {
              final createUrl = 'https://$languageCode.m.wiktionary.org/w/index.php?title=$title&action=edit';
              final createUri = Uri.parse(createUrl);
              if (await canLaunchUrl(createUri)) {
                await launchUrl(
                    createUri, mode: LaunchMode.externalApplication);
              }
              return true;
            }
          }

          // Handle image taps
          if (uri.path.endsWith('.jpg') || uri.path.endsWith('.png') || uri.path.endsWith('.gif') || uri.path.endsWith('.svg')) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ImagePage(imagePath: url), // Assuming this constructor
              ),
            );
            return true;
          }

          // For all other external links, launch them in a browser
          try {
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              throw Exception('Could not launch $url');
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('url_launch_error'.tr()),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
          return true;
        },

        // Also handle taps via the dedicated image tap handler
        // This ensures both <img> tags and <a><img/></a> tags work
        onTapImage: (image) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ImagePage(imagePath: image.sources.first.url), // Assuming this constructor
            ),
          );
        },
      ),
    );
  }
}