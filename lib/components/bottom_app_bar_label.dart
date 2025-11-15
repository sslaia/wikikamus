import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomAppBarLabel extends StatelessWidget {
  const BottomAppBarLabel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        'wiktionary'.tr(),
        textAlign: TextAlign.left,
        style: GoogleFonts.cinzelDecorative(
          textStyle: Theme.of(context).textTheme.displayLarge,
          fontWeight: FontWeight.bold,
          letterSpacing: .7,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
