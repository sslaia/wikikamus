import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikikamus/pages/search_results_page.dart';
import 'package:wikikamus/pages/wiki_page.dart';

class SearchAndCreateDialog extends StatefulWidget {
  final String languageCode;

  const SearchAndCreateDialog({
    super.key,
    required this.languageCode,
  });

  @override
  State<SearchAndCreateDialog> createState() => _SearchAndCreateDialogState();
}

class _SearchAndCreateDialogState extends State<SearchAndCreateDialog> {
  final _searchController = TextEditingController();
  final _createController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _createController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // Action for the "Search" field
  void _submitSearch(String query) {
    if (query.trim().isNotEmpty) {
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => SearchResultsPage(
            languageCode: widget.languageCode,
            query: query.trim(),
          ),
        ),
      );
    }
  }

  // Action for the "Create" field
  void _submitCreate(String title) {
    final newTitle = title.trim().toLowerCase();

    if (newTitle.isNotEmpty) {
      final createUrl =
          'https://${widget.languageCode}.m.wiktionary.org/w/index.php?title=$newTitle&action=edit';
      Navigator.of(context).pop();
      launchUrl(Uri.parse(createUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('search_and_create_page'.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min, // Make the dialog height fit content
        children: [
          TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'search'.tr(),
              hintText: 'enter_a_word_to_find'.tr(),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.search),
            ),
            onSubmitted: _submitSearch,
          ),
          const SizedBox(height: 20), // Spacer between the fields
          TextField(
            controller: _createController,
            decoration: InputDecoration(
              labelText: 'create'.tr(),
              hintText: 'enter_a_word_to_create'.tr(),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.add_outlined),
            ),
            onSubmitted: _submitCreate,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('cancel'.tr()),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
