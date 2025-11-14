import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wikikamus/pages/wiki_page.dart';

class RefreshIconButton extends StatelessWidget {
  const RefreshIconButton({
    super.key,
    required this.languageCode,
    required this.title,
  });

  final String languageCode;
  final String title;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'refresh'.tr(),
      icon: Icon(Icons.refresh_outlined),
      color: Theme.of(context).colorScheme.primary,
      onPressed: () {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (context) => WikiPage(
              languageCode: languageCode, title: title),
          ),
        );
      },
    );
  }
}
