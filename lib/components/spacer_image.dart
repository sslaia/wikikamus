import 'package:flutter/material.dart';

class SpacerImage extends StatelessWidget {
  const SpacerImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/nias/ni'owewemagai.webp"),
            fit: BoxFit.fitHeight,
          )),
    );
  }
}
