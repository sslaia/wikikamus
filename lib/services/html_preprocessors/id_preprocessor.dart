import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'html_preprocessor.dart';

class IndonesianPreprocessor implements HtmlPreprocessor {
  @override
  String process(String rawHtml) {
    try {
      final soup = BeautifulSoup(rawHtml);
      final body = soup.body;
      if (body == null) return '';

      // Find the main content container by its ID
      final content = body.find('div', attrs: {'id': 'mf-index'});

      // Return its outer HTML, or the original HTML as a fallback
      return content?.outerHtml ?? rawHtml;
    } catch (e) {
      return 'Error processing Indonesian HTML: $e';
    }
  }
}
