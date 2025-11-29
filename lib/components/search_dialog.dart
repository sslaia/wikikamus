import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wikikamus/pages/search_results_page.dart';

class SearchDialog extends StatefulWidget {
  final String languageCode;

  const SearchDialog({
    super.key,
    required this.languageCode,
  });

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('search_wiki'.tr()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'search'.tr(),
                hintText: 'enter_a_word_to_find'.tr(),
                hintStyle: TextStyle(fontSize: 11.0, color: Theme.of(context).colorScheme.tertiary),
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: _submitSearch,
            ),
          ],
        ),
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
