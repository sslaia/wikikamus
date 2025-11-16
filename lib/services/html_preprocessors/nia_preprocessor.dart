import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'html_preprocessor.dart';

class NiasPreprocessor implements HtmlPreprocessor {
  @override
  String process(String rawHtml) {
    try {
      final soup = BeautifulSoup(rawHtml);
      final body = soup.body;
      if (body == null) return rawHtml;

      // Find all <section> tags that are explicitly hidden
      final hiddenSections = body.findAll('section', attrs: {
        'style': 'display: none;',
      });

      // Remove the 'style' attribute to make them visible
      for (var section in hiddenSections) {
        section.attributes.remove('style');
      }

      // Extract the relevant main content divs
      // final topBanner = body.find('div', attrs: {'id': 'mp-topbanner-container'});
      // final leftCol = body.find('div', attrs: {'id': 'mp-left'});
      final rightCol = body.find('div', attrs: {'id': 'mp-right'});

      // Combine the HTML of the elements we want to keep
      // final elements = [topBanner, leftCol, rightCol]
      final elements = [rightCol]
          .where((element) => element != null)
          .map((element) => element!.outerHtml)
          .join('');

      return elements.isNotEmpty ? elements : rawHtml;
    } catch (e) {
      return 'Error processing Nias HTML: $e';
    }
  }
}
