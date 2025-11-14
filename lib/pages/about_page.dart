import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  final String title;
  final String html;

  const AboutPage({super.key, required this.title, required this.html});

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleStyle = Theme.of(context).textTheme.titleSmall
        ?.copyWith(color: Theme.of(context).colorScheme.primary);
    final TextStyle? bodyStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontFamily: 'Gelasio');

    return Scaffold(
      body: CustomScrollView(
          slivers: [
            SliverAppBar(
              iconTheme: IconThemeData(
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(title.tr(), style: titleStyle),
              floating: true,
              expandedHeight: 200,
              // flexibleSpace: FlexiblePageHeader(
              //   image: settingsProvider.getProjectPageImage(),
              // ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: HtmlWidget(
                  html,
                  textStyle: bodyStyle,
                  onTapUrl: (url) {
                    launchUrl(Uri.parse(url));
                    return true;
                  },
                ),
              ),
            ),
          ],
        ),
    );
  }
}
