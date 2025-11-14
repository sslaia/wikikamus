import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'html_preprocessor.dart';

class EnglishPreprocessor implements HtmlPreprocessor {
  @override
  String process(String rawHtml) {
    try {
      final soup = BeautifulSoup(rawHtml);
      final body = soup.body;
      if (body == null) return '';

      // A Set is used to automatically handle duplicates if an element has multiple desired classes.
      final Set<Bs4Element> contentElements = {};

      // Find all elements first, then filter them by class.
      // This is a robust way that relies on standard Dart methods.
      body.findAll('*').forEach((element) {
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
        return rawHtml; // Fallback if nothing was found
      }

      // Combine the outer HTML of the found elements
      return contentElements.map((e) => e.outerHtml).join('');
    } catch (e) {
      return 'Error processing English HTML: $e';
    }
  }
}
