import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  final String imagePath;

  const ImagePage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle =
    Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.primary);
    final TextStyle? titleStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Theme.of(context).colorScheme.primary);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'image_viewer'.tr(),
          style: titleStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              InteractiveViewer(
                boundaryMargin: EdgeInsets.zero,
                minScale: 0.5,
                maxScale: 3.0,
                child: Image.network(
                  imagePath,
                  width: double.infinity,
                  // height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Source: Wikimedia Commons ($imagePath)',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
