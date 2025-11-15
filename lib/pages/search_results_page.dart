import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:provider/provider.dart';
import 'package:wikikamus/pages/wiki_page.dart';
import 'package:wikikamus/services/api_service.dart';

import '../models/search_result.dart';
import '../providers/settings_provider.dart';

class SearchResultsPage extends StatefulWidget {
  final String languageCode;
  final String query;

  const SearchResultsPage({
    super.key,
    required this.query,
    required this.languageCode,
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final ApiService _apiService = ApiService();
  final ScrollController _scrollController =
      ScrollController();
  List<SearchResult> _searchResults = [];
  bool _isLoading = true;
  String _error = '';

  int? _nextOffset;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _fetchSearchResults();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _nextOffset != null &&
          !_isFetchingMore) {
        _fetchMoreSearchResults();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchSearchResults() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final searchData = await _apiService.searchWiktionary(
        languageCode: widget.languageCode,
        query: widget.query,
      );
      setState(() {
        _searchResults = searchData['results'] as List<SearchResult>;
        _nextOffset = searchData['nextOffset'] as int?;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'search_error_occurred: $e'.tr();
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchMoreSearchResults() async {
    setState(() {
      _isFetchingMore = true;
    });

    try {
      final searchData = await _apiService.searchWiktionary(
        languageCode: widget.languageCode,
        query: widget.query,
        sroffset: _nextOffset,
      );
      setState(() {
        _searchResults.addAll(searchData['results'] as List<SearchResult>);
        _nextOffset = searchData['nextOffset'] as int?;
        _isFetchingMore = false;
      });
    } catch (e) {
      setState(() {
        _error = 'search_error_occurred: $e'.tr();
        _isFetchingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) => Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              'search_results'.tr(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            actions: [
              // TODO: create a new page button
              // CreateNewPageIconButton(destination: CreateNewEntry())
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error.isNotEmpty
              ? Center(
                  child: Text(
                    _error,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                )
              : _searchResults.isEmpty
              ? Center(child: Text('search_no_results').tr())
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount:
                            _searchResults.length + (_isFetchingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _searchResults.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final result = _searchResults[index];
                          final title = result.title;
                          final decodeSnippet = HtmlCharacterEntities.decode(
                            result.snippet,
                          );
                          final snippet = decodeSnippet.replaceAll(
                            RegExp(r'<[^>]*>'),
                            '',
                          );

                          return ListTile(
                            title: Text(title),
                            subtitle: Text(
                              snippet,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              // Navigate to WikiPage with the title
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WikiPage(
                                    languageCode: widget.languageCode,
                                    title: title,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
