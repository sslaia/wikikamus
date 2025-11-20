import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class NiasMainHeader extends StatelessWidget {
  const NiasMainHeader({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        NormalText(text: 'greeting_nias'),
        const SizedBox(height: 16.0),
        Text(
            'Wikikamus Nias',
            style: GoogleFonts.cinzelDecorative(
              textStyle: Theme.of(context).textTheme.displayLarge,
              fontWeight: FontWeight.bold,
              letterSpacing: .7,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16.0),
        NormalText(text: 'goal_nias'),
        NormalText(text: 'motto_nias'),
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
