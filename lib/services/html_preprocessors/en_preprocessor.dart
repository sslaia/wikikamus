import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'html_preprocessor.dart';

class EnglishPreprocessor implements HtmlPreprocessor {
  @override
  String process(String rawHtml) {
    try {
      final soup = BeautifulSoup(rawHtml);
      final body = soup.body;
      if (body == null) return '';

      final Set<Bs4Element> contentElements = {};

      // Find all elements that will be shown in the app
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
        return rawHtml;
      }

      return contentElements.map((e) => e.outerHtml).join('');
    } catch (e) {
      return 'Error processing the HTML: $e';
    }
  }
}
