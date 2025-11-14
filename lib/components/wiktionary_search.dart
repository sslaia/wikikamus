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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        onSubmitted: (String str) {
          if (str.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchResultsPage(languageCode: widget.languageCode, query: str),
              ),
            );
          }
        },
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        decoration: InputDecoration(
          labelText: "search_what".tr(),
          labelStyle: TextStyle(fontSize: 10.0, color: Theme.of(context).colorScheme.tertiary),
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}