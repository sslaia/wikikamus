import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wikikamus/pages/home_page.dart';
import 'package:wikikamus/providers/settings_provider.dart';

class HomeIconButton extends StatelessWidget {
  const HomeIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) => IconButton(
        tooltip: 'home'.tr(),
        icon: Icon(Icons.home_outlined),
        color: Theme.of(context).colorScheme.primary,
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
                (Route<dynamic> route) => false
          );
        },
      ),
    );
  }
}
