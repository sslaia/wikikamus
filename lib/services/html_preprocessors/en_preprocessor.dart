import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:wikikamus/services/html_preprocessors/default_preprocessor.dart';
import 'package:wikikamus/services/html_preprocessors/html_preprocessor.dart';

class EnglishPreprocessor implements HtmlPreprocessor {
  final _defaultProcessor = DefaultPreprocessor();

  @override
  String process(String rawHtml) {
    // Run the default cleanups first
    final initialCleanedHtml = _defaultProcessor.process(rawHtml);

    // Run English Wiktionary spedific cleanup
    try {
      final soup = BeautifulSoup(initialCleanedHtml);
      final root = soup.body;
      if (root == null) {
        return '';
      }

      final Set<Bs4Element> contentElements = {};

      // Find all elements that will be shown in the app
      root.findAll('*').forEach((element) {
        String? elementClasses = element.attributes['class'];
        if (elementClasses != null) {
          if (elementClasses.contains('main-page-body-text') ||
              elementClasses.contains('mf-wotd') ||
              elementClasses.contains('mf-fwotd')) {
            contentElements.add(element);
          }
        }
      });

      if (contentElements.isEmpty) {
        return rawHtml;
      }

      return contentElements.map((e) => e.outerHtml).join('');
    } catch (e) {
      return 'Error processing the HTML: $e';
    }
  }
}
