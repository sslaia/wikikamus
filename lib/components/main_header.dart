import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainHeader extends StatelessWidget {
  final String language;
  const MainHeader({super.key, required this.language});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        NormalText(text: 'greeting'),
        const SizedBox(height: 16.0),
        Text(
          '${'wiktionary'.tr()} $language',
          style: GoogleFonts.cinzelDecorative(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16.0),
        NormalText(text: 'motto'),
      ],
    );
  }
}

class NormalText extends StatelessWidget {
  const NormalText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr(),
      style: Theme.of(context).textTheme.bodySmall,
      textAlign: TextAlign.center,
    );
  }
}
