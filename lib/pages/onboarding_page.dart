import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:wikikamus/pages/settings_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(builder: (context) => const SettingsPage()),
              );
            },
            child: Text('continue'.tr()),
          ),
        ),
      ),
    );
  }
}
