import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:wikikamus/utils/get_lowercase_title_from_url.dart';

class ContentBody extends StatelessWidget {
  const ContentBody({
    super.key,
    required this.html,
    required this.onExistentLinkTap,
    required this.onNonExistentLinkTap,
    required this.onImageLinkTap,
  });

  final String html;
  final void Function(String newPageTitle) onExistentLinkTap;
  final void Function(String newTitle) onNonExistentLinkTap;
  final void Function(String imgUrl) onImageLinkTap;

  @override
  Widget build(BuildContext context) {
    final baseTextStyle =
        Theme.of(context).textTheme.bodyMedium ?? const TextStyle();

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: HtmlWidget(
        html,
        buildAsync: true,
        renderMode: RenderMode.column,
        textStyle: GoogleFonts.gelasio(
          textStyle: Theme.of(context).textTheme.bodyMedium,
        ),

        /// Customization for mobile display
        customStylesBuilder: (element) {
          /// Reduce the size of all heading elements
          /// as they appear too huge on mobile screens
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

          // Handle links that start with "./" (the main page)
          if (url.startsWith('./')) {
            final title = url.substring(2);
            onExistentLinkTap(title);
            return true;
          }

          // Handle existent internal wiki links (the wikip age)
          if (uri.path.startsWith('/wiki/')) {
            final title = uri.pathSegments.last;
            onExistentLinkTap(title);
            return true;
          }

          // Handle non-existent internal wiki links (the wiki page)
          if (uri.path.startsWith('/w/')) {
            final title = getLowercaseTitleFromUrl(url);
            onNonExistentLinkTap(title);
            return true;
          }

          // For all other external links, launch them in a browser
          try {
            final launchable = await canLaunchUrl(uri);
            if (launchable) {
              await launchUrl(uri);
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('url_launch_error'.tr()),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
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

        /// Handling of images
        onTapImage: (image) {
          onImageLinkTap(image.sources.first.url);
        },
      ),
    );
  }
}
