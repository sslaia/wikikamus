import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'html_preprocessor.dart';

class IndonesianPreprocessor implements HtmlPreprocessor {
  @override
  String process(String rawHtml) {
    try {
      final soup = BeautifulSoup(rawHtml);
      final root = soup.body;
      if (root == null) {
        return '';
      }

      /// Di bawah ini adalah kode untuk menyaring konten halaman wiki secara umum
      /// yang berlaku untuk semua situs Wiktionary.

      // Hapus tombol/pranala "[sunting]" (edit section links)
      _removeElements(root, '.mw-editsection');

      // Hapus daftar isi (table of contents)
      _removeElements(root, '.toc, #toc');

      /// Konten Halaman Utama Wikikamus Indonesia
      /// ada dalam table di <div id="mf-index">
      final mainPageContent = root.find('div', attrs: {'id': 'mf-index'});

      if (mainPageContent != null) {
        return mainPageContent.outerHtml;
      } else {
        return root.toString();
      }
    } catch (e) {
      return 'Error processing the HTML: $e';
    }
  }

  /// Helper function to remove all elements matching a CSS selector.
  void _removeElements(Bs4Element root, String selector) {
    root.findAll(selector).forEach((element) => element.extract());
  }
}
