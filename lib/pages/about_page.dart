import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  final String title;
  final String html;

  const AboutPage({super.key, required this.title, required this.html});

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = GoogleFonts.cinzelDecorative(
      textStyle: Theme.of(context).textTheme.titleSmall,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.secondary,
    );
    final TextStyle bodyStyle = GoogleFonts.gelasio(
      textStyle: Theme.of(context).textTheme.bodyMedium,
      color: Theme.of(context).colorScheme.secondary,
    );

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
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          'assets/images/wiktionary.webp',
                          fit: BoxFit.fitHeight,
                          width: double.infinity,
                          height: 150,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
