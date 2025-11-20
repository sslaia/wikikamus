import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wikikamus/components/search_and_create_dialog.dart';
import 'package:wikikamus/components/search_dialog.dart';

class SearchIconButton extends StatelessWidget {
  final String languageCode;

  const SearchIconButton({
    super.key,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'search'.tr(),
      icon: const Icon(Icons.search),
      color: Theme.of(context).colorScheme.primary,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SearchDialog(languageCode: languageCode);
          },
        );
      },
    );
  }
}
