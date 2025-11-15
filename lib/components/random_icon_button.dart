import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wikikamus/pages/wiki_page.dart';
import 'package:wikikamus/services/api_service.dart';

class RandomIconButton extends StatefulWidget {
  const RandomIconButton({super.key, required this.languageCode});

  final String languageCode;

  @override
  State<RandomIconButton> createState() => _RandomIconButtonState();
}

class _RandomIconButtonState extends State<RandomIconButton> {
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  Future<void> _findAndNavigateToRandomPage() async {
    // Prevent multiple clicks while loading.
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      // Fetch a single random title.
      final String? randomTitle = await _apiService.fetchSingleRandomTitle(languageCode: widget.languageCode);

      if (mounted && randomTitle != null) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => WikiPage(languageCode: widget.languageCode, title: randomTitle),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not find a random page.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      // Always stop loading.
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'random'.tr(),
      // Show loading indicator or icon
      icon: _isLoading
          ? SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          color: Theme.of(context).colorScheme.primary,
        ),
      )
          : const Icon(Icons.shuffle_outlined),
      color: Theme.of(context).colorScheme.primary,
      onPressed: _findAndNavigateToRandomPage,
    );
  }
}
