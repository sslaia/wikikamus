import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:wikikamus/services/html_preprocessors/default_preprocessor.dart';
import 'package:wikikamus/services/html_preprocessors/html_preprocessor.dart';

/// NOTE: Temporary solution before local Indonesian Wiktionaries admins
/// agree to use modern, mobile first, responsive design.
/// When that happens, this class only contains specific cases.

class NiasPreprocessor implements HtmlPreprocessor {
  final _defaultProcessor = DefaultPreprocessor();

  @override
  String process(String rawHtml) {
    // Run default cleanups first
    final initialCleanedHtml = _defaultProcessor.process(rawHtml);

    // Nias specific cleanup
    try {
      final soup = BeautifulSoup(initialCleanedHtml);
      final root = soup.body;
      if (root == null) {
        return '';
      }

      // Remove empty sections marked with "Lö hadöi"
      _removeEmptySections(root);

      // Remove empty Gambara sections
      _removeEmptyImageSections(root);

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
      final mainContent = root.find('div', attrs: {'id': 'mp-content'});
      if (mainContent != null) {
        // If we found the main page content wrapper, return ONLY that.
        return mainContent.outerHtml;
      }

      final mainPageRightColumn = root.find('div', attrs: {'id': 'mp-right'});
      if (mainPageRightColumn != null) {
        // This is a fallback for the main page if the structure uses 'mp-right'.
        // Find all <section> tags within the right column that are explicitly hidden
        final hiddenSections = mainPageRightColumn.findAll(
          'section',
          attrs: {'style': 'display: none;'},
        );
        // Remove the 'style' attribute to make them visible
        for (var section in hiddenSections) {
          section.attributes.remove('style');
        }

        return mainPageRightColumn.outerHtml;
      }
      return root.toString();
    } catch (e) {
      return 'Error processing Nias HTML: $e';
    }
  }

  /// Helper function to find and remove headings followed by "Lö hadöi"
  /// in either <dd> or <li> tags.
  void _removeEmptySections(Bs4Element root) {
    // Find all 'dd' and 'li' elements.
    final potentialMarkers = root.findAll('dd') + root.findAll('li');

    // Use Dart's .where() to filter them based on their content
    final emptyMarkers = potentialMarkers.where((element) {
      return element.string.trim() == 'Lö hadöi';
    });

    for (final marker in emptyMarkers) {
      Bs4Element? listContainer;

      // Determine the parent list container
      if (marker.name == 'dd') {
        listContainer = marker.findParent('dl');
      } else if (marker.name == 'li') {
        // It could be in a <ul> or <ol>
        listContainer = marker.findParent('ul') ?? marker.findParent('ol');
      }

      if (listContainer == null) continue;

      // Find the heading element that comes just before the list container
      final headingDiv = listContainer.findPreviousSibling('div');

      // To be safe, check if the found sibling is actually a heading container.
      if (headingDiv != null && headingDiv.className.contains('mw-heading')) {
        // Remove the heading and the list container.
        headingDiv.extract();
        listContainer.extract();
      }
    }
  }

  /// Helper function to remove the "Gambara" heading if it has no pictures.
  void _removeEmptyImageSections(Bs4Element root) {
    final imageHeadings = root.findAll('h3', id: 'Gambara');

    for (final h3 in imageHeadings) {
      final headingContainer = h3.findParent('div');
      if (headingContainer == null) continue;

      final Bs4Element? nextElement = headingContainer.nextSibling;

      if (nextElement == null || nextElement.name != 'figure') {
        headingContainer.extract();
      }
    }
  }
}
