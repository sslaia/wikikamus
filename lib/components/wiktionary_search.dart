import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wikikamus/pages/search_results_page.dart';

class WiktionarySearch extends StatefulWidget {
  final String languageCode;

  const WiktionarySearch({super.key, required this.languageCode});

  @override
  State<WiktionarySearch> createState() => _WiktionarySearchState();
}

class _WiktionarySearchState extends State<WiktionarySearch> {

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitSearch(String query) {
    if (query.trim().isNotEmpty) {
      _searchController.clear();
      _focusNode.unfocus();
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
    return TextField(
      controller: _searchController,
      focusNode: _focusNode,
      decoration: InputDecoration(
        labelText: 'search_what'.tr(),
        hintText: 'enter_a_word_to_find'.tr(),
        hintStyle:
        TextStyle(fontSize: 11.0, color: Theme.of(context).colorScheme.tertiary),
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.search),
      ),
      onSubmitted: _submitSearch,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      // decoration: InputDecoration(
      //   labelText: "search_what".tr(),
      //   labelStyle: TextStyle(fontSize: 10.0, color: Theme.of(context).colorScheme.tertiary),
      //   prefixIcon: Icon(Icons.search),
      //   border: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(8.0),
      //   ),
      // ),
    );
  }
}