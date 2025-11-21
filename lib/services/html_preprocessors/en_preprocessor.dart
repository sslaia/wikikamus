import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'html_preprocessor.dart';

class EnglishPreprocessor implements HtmlPreprocessor {
  @override
  String process(String rawHtml) {
    try {
      final soup = BeautifulSoup(rawHtml);
      final root = soup.body;
      if (root == null) {
        return '';
      }

      // Remove edit text buttons
      _removeElements(root, '.mw-editsection');

      // Remove table of contents
      _removeElements(root, '.toc, #toc');

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

  /// Helper function to remove all elements matching a CSS selector.
  void _removeElements(Bs4Element root, String selector) {
    root.findAll(selector).forEach((element) => element.extract());
  }
}
