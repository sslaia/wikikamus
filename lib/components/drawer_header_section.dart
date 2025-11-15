import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerHeaderSection extends StatelessWidget {
  const DrawerHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/wiktionary.webp"),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            'Wikikamus',
            style: GoogleFonts.cinzelDecorative(
              textStyle: Theme.of(context).textTheme.displayLarge,
              fontWeight: FontWeight.bold,
              letterSpacing: .7,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );
  }
}