// This is the contract for all our preprocessors.
// Any class that processes HTML must have a 'process' method.
abstract class HtmlPreprocessor {
  String process(String rawHtml);
}