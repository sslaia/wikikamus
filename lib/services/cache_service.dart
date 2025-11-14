import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikikamus/services/api_service.dart';

class CacheService {
  final SharedPreferences _prefs;
  final ApiService _apiService;

  // It gets its dependencies passed in. This is a clean pattern.
  CacheService(this._prefs, this._apiService);

  /// Gets the main page content.
  /// It checks the cache first, and if that fails, it fetches from the network,
  /// saves the result, and then returns it.
  Future<String> getMainPageContent({
    required String languageCode,
    required String title,
  }) async {
    final contentKey = '${languageCode}_main_page_content';
    final timestampKey = '${languageCode}_main_page_timestamp';

    final String? cachedContent = _prefs.getString(contentKey);
    final int? timestamp = _prefs.getInt(timestampKey);
    final now = DateTime.now();

    if (cachedContent != null && timestamp != null) {
      final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (now.difference(cachedTime).inDays < 0) {
        return cachedContent;
      }
    }

    /// Fetch the content from the internet if no cache is empty or expired
    final networkContent = await _apiService.fetchAndProcessMainPage(
      languageCode: languageCode,
      title: title,
    );

    /// Save the new content to cache before returning.
    if (!networkContent.toLowerCase().startsWith('error:')) {
      await _prefs.setString(contentKey, networkContent);
      await _prefs.setInt(timestampKey, now.millisecondsSinceEpoch);
    }

    return networkContent;
  }

  /// Fetches any other wiki page without caching.
  Future<String> getWikiPageContent({
    required String languageCode,
    required String title,
  }) async {
    return _apiService.fetchPageContent(languageCode: languageCode, title: title);
  }
}
