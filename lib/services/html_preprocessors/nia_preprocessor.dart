import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'html_preprocessor.dart';

class NiasPreprocessor implements HtmlPreprocessor {
  @override
  String process(String rawHtml) {
    try {
      final soup = BeautifulSoup(rawHtml);
      final root = soup.body ?? soup;

      // Remove edit text buttons, as they are irrelevant in display mode
      final editSections = root.findAll('*', attrs: {'class': 'mw-editsection'});
      for (var editSection in editSections) {
        editSection.extract();
      }

      // Remove table of contents as they annoyingly occupies the whole screen
      // (usually appeared on Nias wiktionary pages)
      final tableOfContents = root.findAll('*', attrs: {'class': 'toc'});
      for (var tocElement in tableOfContents) {
        tocElement.extract();
      }
      final toc = root.findAll('*', attrs: {'id': 'toc'});
      for (var tocElement in toc) {
        tocElement.extract();
      }

      // --- Handle the main page -- //

      // Find all <section> tags that are explicitly hidden
      // final hiddenSections = root.findAll('section', attrs: {
      //   'style': 'display: none;',
      // });
      // for (var section in hiddenSections) {
      //   section.attributes.remove('style');
      // }

      /// The following solution is for extracting
      /// the top, left and right columns contents
      /// and left out everything else

      // final topBanner = root.find('div', attrs: {'id': 'mp-topbanner-container'});
      // final leftCol = root.find('div', attrs: {'id': 'mp-left'});
      // final rightCol = root.find('div', attrs: {'id': 'mp-right'});

      // final elements = [topBanner, leftCol, rightCol]
      //     .where((element) => element != null)
      //     .map((element) => element!.outerHtml)
      //     .join('');
      // return elements.isNotEmpty ? elements : rawHtml;

      /// The following solution is for exctracting
      /// only the right colum contents
      /// which could change if the original website is redesigned
      final mainPageRightColumn = root.find('div', attrs: {'id': 'mp-right'});

      if (mainPageRightColumn != null) {
        // Find all <section> tags within the right column that are explicitly hidden
        final hiddenSections = mainPageRightColumn.findAll('section', attrs: {
          'style': 'display: none;',
        });
        // Remove the 'style' attribute to make them visible
        for (var section in hiddenSections) {
          section.attributes.remove('style');
        }

        // Return only the HTML of the processed right column
        return mainPageRightColumn.outerHtml;
      } else {
        // IT'S AN ARTICLE PAGE: Return the whole cleaned content
        // The universal cleaning has already run.
        return root.toString();
      }
    } catch (e) {
      return 'Error processing Nias HTML: $e';
    }
  }
}
