import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:wikikamus/services/html_preprocessors/default_preprocessor.dart';
import 'package:wikikamus/services/html_preprocessors/html_preprocessor.dart';

class JavanesePreprocessor implements HtmlPreprocessor {
  final _defaultProcessor = DefaultPreprocessor();

  @override
  String process(String rawHtml) {
    // Jalankan penyaringan umum lebih dulu
    final initialCleanedHtml = _defaultProcessor.process(rawHtml);

    // Saringan khusus untuk Wikikamus Bahasa Jawa
    try {
      final soup = BeautifulSoup(initialCleanedHtml);
      final root = soup.body;
      if (root == null) {
        return '';
      }

      // Di sini penyaringan sejauh diperlukan

      // Serelah selesai penyaringan kembalikan konten di dalam <body>
      return root.toString();
    } catch (e) {
      return 'Error processing the HTML: $e';
    }
  }
}
