import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:wikikamus/models/recent_changes.dart';
import 'package:wikikamus/models/search_result.dart';
import 'package:wikikamus/services/html_preprocessors/bew_preprocessor.dart';
import 'package:wikikamus/services/html_preprocessors/bjn_preprocessor.dart';
import 'package:wikikamus/services/html_preprocessors/btm_preprocessor.dart';

import 'package:wikikamus/services/html_preprocessors/en_preprocessor.dart';
import 'package:wikikamus/services/html_preprocessors/gor_preprocessor.dart';
import 'package:wikikamus/services/html_preprocessors/html_preprocessor.dart';
import 'package:wikikamus/services/html_preprocessors/id_preprocessor.dart';
import 'package:wikikamus/services/html_preprocessors/jv_preprocessor.dart';
import 'package:wikikamus/services/html_preprocessors/mad_preprocessor.dart';
import 'package:wikikamus/services/html_preprocessors/min_preprocessor.dart';
import 'package:wikikamus/services/html_preprocessors/ms_preprocessor.dart';
import 'package:wikikamus/services/html_preprocessors/nia_preprocessor.dart';
import 'package:wikikamus/services/html_preprocessors/default_preprocessor.dart';
import 'package:wikikamus/services/html_preprocessors/su_preprocessor.dart';

class ApiService {
  final http.Client _client;

  /// A map to hold our preprocessor
  /// The purpose of this is to allow each language to have its own strategy
  /// how to process the page
  final Map<String, HtmlPreprocessor> _preprocessors = {
    'bew': BetawiPreprocessor(),
    'bjn': BanjarPreprocessor(),
    'btm': BatakMandailingPreprocessor(),
    'en': EnglishPreprocessor(),
    'gor': GorontaloPreprocessor(),
    'id': IndonesianPreprocessor(),
    'jv': JavanesePreprocessor(),
    'mad': MaduresePreprocessor(),
    'min': MinangkabauPreprocessor(),
    'ms': MalayPreprocessor(),
    'nia': NiasPreprocessor(),
    'su': SundanesePreprocessor()
  };

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// This private helper method selects the correct processor
  HtmlPreprocessor _getPreprocessorFor(String languageCode) {
    return _preprocessors[languageCode] ?? DefaultPreprocessor();
  }

  /// Fetches the main page content, processes it, and returns the result.
  Future<String> fetchAndProcessMainPage({
    required String languageCode,
    required String title,
  }) async {
    final rawHtml = await _fetchRawContent(
      languageCode: languageCode,
      title: title,
    );

    if (rawHtml.toLowerCase().startsWith('error:')) {
      return rawHtml;
    }

    final preprocessor = _getPreprocessorFor(languageCode);
    final processedHtml = preprocessor.process(rawHtml);
    return processedHtml;
  }

  /// Fetches any other page that needs to be preprocessed
  Future<String> fetchPageContent({
    required String languageCode,
    required String title,
  }) async {
    final rawHtml = await _requestPageContent(
      languageCode: languageCode,
      title: title,
    );
    if (rawHtml.toLowerCase().startsWith('error:')) {
      return rawHtml;
    }

    final preprocessor = _getPreprocessorFor(languageCode);
    final processedHtml = preprocessor.process(rawHtml);
    return processedHtml;
  }

  /// Private helper to get page raw content from the MediaWiki API.
  Future<String> _requestPageContent({
    required String languageCode,
    required String title,
  }) async {
    final appAgent =
        "Wikikamus Android app/1.0 (https://github.com/uuser/wikikamus; slaia@yahoo.com)";
    final uri = Uri.https('$languageCode.m.wiktionary.org', '/w/api.php', {
      // action=parse&page=$title&prop=text&formatversion=2&format=json&mobileformat=true
      'action': 'parse',
      'page': title,
      'prop': 'text',
      'formatversion': '2',
      'format': 'json',
      'mobileformat': 'true',
    });
    try {
      final response = await http.get(uri, headers: {'User-Agent': appAgent});
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('parse') && data['parse'].containsKey('text')) {
          return data['parse']['text'];
        } else {
          return 'Error: Invalid API response format.';
        }
      } else {
        return 'Error: Failed to load page. Status: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  /// Private helper to get Main Page raw content from the MediaWiki API.
  Future<String> _fetchRawContent({
    required String languageCode,
    required String title,
  }) async {
    final appAgent =
        "Wikikamus Android app/1.0 (https://github.com/uuser/wikikamus; slaia@yahoo.com)";

    // REST API endpoint for mobile-optimized HTML
    final uri = Uri.parse(
      'https://$languageCode.wiktionary.org/api/rest_v1/page/mobile-html/$title?redirect=false',
    );

    try {
      final response = await http.get(uri, headers: {'User-Agent': appAgent});

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Handle redirects if the page was moved
        if (response.statusCode == 302) {
          return 'Error: Page has been moved. Redirects are not yet handled.';
        }
        return 'Error: Failed to load page. Status: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: An exception occurred while fetching content: $e';
    }
  }

  /// Fetches the mobile-optimized HTML content using REST API
  Future<String> fetchHtmlContent({
    required String languageCode,
    required String title,
  }) async {
    final appAgent =
        "Wikikamus Android app/1.0 (https://github.com/uuser/wikikamus; slaia@yahoo.com)";

    // REST API endpoint for mobile-optimized HTML
    final uri = Uri.parse(
      'https://$languageCode.wiktionary.org/api/rest_v1/page/mobile-html/$title',
    );

    try {
      final response = await http.get(uri, headers: {'User-Agent': appAgent});

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Handle redirects if the page was moved
        if (response.statusCode == 302) {
          return 'Error: Page has been moved. Redirects are not yet handled.';
        }
        return 'Error: Failed to load page. Status: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error: An exception occurred while fetching content: $e';
    }
  }

  /// Fetches the recent changes
  Future<List<RecentChanges>> fetchRecentChanges({
    required String languageCode,
    int limit = 50,
  }) async {
    final uri = Uri.https('$languageCode.m.wiktionary.org', '/w/api.php', {
      'action': 'query',
      'list': 'recentchanges',
      'rcprop': 'title|ids|sizes|flags|user|comment',
      'rclimit': limit.toString(),
      'format': 'json',
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return compute(_parseRecentChanges, response.body);
      } else {
        throw Exception(
          'Failed to load recent changes: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching recent changes: $e');
    }
  }

  Future<List<RecentChanges>> _parseRecentChanges(String responseBody) async {
    final Map<String, dynamic> data = jsonDecode(responseBody);

    if (data.containsKey('query') &&
        data['query'].containsKey('recentchanges')) {
      final List<dynamic> changesList = data['query']['recentchanges'];
      return changesList
          .map((jsonItem) => RecentChanges.fromJson(jsonItem))
          .toList();
    } else {
      throw Exception('Unexpected JSON structure from Wikipedia API');
    }
  }

  // fetch random wiki pages
  Future<String?> fetchSingleRandomTitle({required String languageCode}) async {
    final queryParams = {
      'format': 'json',
      'action': 'query',
      'list': 'random',
      'rnnamespace': '0',
      'rnlimit': '1',
    };

    try {
      final response = await http.get(
        Uri.parse(
          'https://$languageCode.wiktionary.org/w/api.php',
        ).replace(queryParameters: queryParams),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final randomPages = data['query']['random'] as List?;

        if (randomPages != null && randomPages.isNotEmpty) {
          return randomPages[0]['title'] as String?;
        }
        return null;
      } else {
        throw Exception(
          'Failed to load random page: Status code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to the wiki server.');
    }
  }

  /// Search for a page on Wiktionary
  Future<Map<String, dynamic>?> searchWiktionary({
    required String languageCode,
    required String query,
    int? sroffset,
  }) async {
    final uri = Uri.https(
      '$languageCode.wiktionary.org',
      '/w/api.php',
      {
        'action': 'query',
        'list': 'search',
        'srsearch': query,
        'srnamespace': '0',
        'format': 'json',
        'srlimit': '20',
        if (sroffset != null) 'sroffset': sroffset.toString(),
      },
    );

    try {
      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['query'] == null || data['query']['search'] == null) {
          return null;
        }

        final List<SearchResult> results = (data['query']['search'] as List)
            .map((item) => SearchResult.fromJson(item))
            .toList();

        final int? nextOffset = data['continue']?['sroffset'];

        return {
          'results': results,
          'nextOffset': nextOffset,
        };
      } else {
        throw Exception('Failed to load search results: ${response.statusCode}');
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<SearchResult>> parseSearch(String responseBody) async {
    final wikiResponse = wikiResponseFromJson(responseBody);
    return wikiResponse.query?.search.toList() ?? [];
  }
}
