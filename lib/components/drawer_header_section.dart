import 'package:flutter/material.dart';

class DrawerHeaderSection extends StatelessWidget {
  const DrawerHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/nias/ni'obutelai.webp"),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            'Wikikamus',
            style: TextStyle(
              // fontFamily: 'CinzelDecorative',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );
  }
}