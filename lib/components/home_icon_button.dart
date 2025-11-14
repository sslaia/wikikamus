import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeIconButton extends StatelessWidget {
  const HomeIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'home'.tr(),
      icon: Icon(Icons.home_outlined),
      color: Theme.of(context).colorScheme.primary,
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
      },
    );
  }
}
