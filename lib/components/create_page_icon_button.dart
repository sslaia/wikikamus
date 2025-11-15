import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePageIconButton extends StatelessWidget {
  final Widget destination;

  const CreatePageIconButton({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        tooltip: 'create_new_page'.tr(),
        icon: Icon(Icons.edit_outlined),
        color: Theme.of(context).colorScheme.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => destination),
          );
        },
    );
  }
}