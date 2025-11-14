import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RefreshHomeIconButton extends StatelessWidget {
  const RefreshHomeIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'refresh'.tr(),
      icon: Icon(Icons.refresh_outlined),
      color: Theme.of(context).colorScheme.primary,
      onPressed: () {
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
      },
    );
  }
}
