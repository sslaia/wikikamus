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

      /// The following solution is for exctracting the contents
      /// which reside in div with mp-content id
      /// This would be redundant when the website code changes
      final mainContent = root.find('div', attrs: {'id': 'mp-content'});
      if (mainContent != null) {
        // --- THIS IS THE NEW LOGIC ---
        // Filter the main page to only include the sections we want.
        _filterMainPageContent(mainContent);
        // --- END OF NEW LOGIC ---

        _cleanUpStyles(mainContent);

        // If we found the main page content wrapper, return ONLY that.
        return mainContent.outerHtml;
      }

      return root.innerHtml;
    } catch (e) {
      return 'Error processing Nias HTML: $e';
    }
  }

  /// NEW: Helper function to keep only specific sections of the main page.
  void _filterMainPageContent(Bs4Element mainContent) {
    final sectionsToKeepIds = [
      'mp-featured-word',
      'mp-dyk',
    ];

    // Find all direct children sections within the main content div.
    final allSections = mainContent.findAll(
      'div',
      attrs: {'class': 'mp-content-section'},
    );

    final directChildrenSections = allSections.where(
            (section) => section.parent?.attributes['id'] == 'mp-content');

    for (final section in directChildrenSections) {
      // If a section's ID is NOT in our list of sections to keep, remove it.
      if (!sectionsToKeepIds.contains(section.attributes['id'])) {
        section.extract();
      }
    }
  }

  /// Helper function to clean up problematic CSS styles from the main content.
  void _cleanUpStyles(Bs4Element element) {
    // Find all elements that have a 'style' attribute.
    final allElements = element.findAll('*');
    final styledElements =
    allElements.where((el) => el.attributes.containsKey('style'));

    for (final el in styledElements) {
      final style = el.attributes['style'];
      if (style == null) continue;

      // For elements with "display: none", simply remove the style attribute entirely
      // to make them visible. This is the main fix.
      if (style.contains('display: none')) {
        el.attributes.remove('style');
        continue; // Move to the next element
      }

      // For other styled elements, remove only the flexbox rules.
      var rules = style.split(';').map((s) => s.trim()).toList();
      rules.removeWhere((rule) =>
      rule.startsWith('display: flex') ||
          rule.startsWith('flex-direction') ||
          rule.startsWith('align-items') ||
          rule.startsWith('justify-content'));

      // Rejoin the cleaned rules and update the style attribute
      final newStyle = rules.join('; ');
      if (newStyle.trim().isEmpty) {
        el.attributes.remove('style');
      } else {
        el.attributes['style'] = newStyle;
      }
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

