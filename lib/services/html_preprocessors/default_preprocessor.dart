import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'html_preprocessor.dart';

class DefaultPreprocessor implements HtmlPreprocessor {
  @override
  String process(String rawHtml) {
    // final dom.Document document = parser.parse(rawHtml);

    // // Perform only the most generic cleanup
    // // A fix for giant heading in HtmlWidget
    // document.querySelectorAll('h2').forEach((h2) {
    //   final String h2Text = h2.text;
    //   h2.attributes.clear();
    //   h2.innerHtml = h2Text;
    // });
    //
    // // hide elements that should be hidden on mobile
    // document.querySelectorAll('.nomobile').forEach((e) => e.remove());
    // // remove edit section, which is irrelevant inside the app
    // document.querySelectorAll('.mw-editsection').forEach((e) => e.remove());
    // // remove all inline styles that don't play nice with HtmlWidget
    // document.querySelectorAll('[style]').forEach((e) => e.attributes.remove('style'));

    // return document.body?.innerHtml ?? '';
    return rawHtml;
  }
}
