import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:wikikamus/services/html_preprocessors/default_preprocessor.dart';
import 'package:wikikamus/services/html_preprocessors/html_preprocessor.dart';

class IndonesianPreprocessor implements HtmlPreprocessor {
  final _defaultProcessor = DefaultPreprocessor();

  @override
  String process(String rawHtml) {
    // Jalankan penyaringan umum lebih dulu
    final initialCleanedHtml = _defaultProcessor.process(rawHtml);

    // Saringan khusus untuk Wikikamus Bahasa Indonesia
    try {
      final soup = BeautifulSoup(initialCleanedHtml);
      final root = soup.body;
      if (root == null) {
        return '';
      }

      // Konten Halaman Utama Wikikamus Indonesia
      // Saat ini ada dalam sebuah table di dalam <div id="mf-index">
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
}
