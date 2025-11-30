// this is use for making the title look nicer without the namespace names
String processedTitle(String title) {
  const prefixes = {
    "Bhântowan:": 10,
    "Bantuan:": 8,
    "Fanolo:": 7,
    "Help:": 5,
    "Husus:": 6,
    "Istimewa:": 9,
    "Istimèwa:": 9,
    "Istimiwa": 9,
    "Khas:": 6,
    "Mirunggan:": 10,
    "Pitulung:": 9,
    "Portal:": 7,
    "Special:": 8,
    "Spesial:": 8,
    "Wikibooks:": 10,
    "Wikikamus:": 10,
    "Wikikato:": 9,
    "Wikipedia:": 10,
    "Wikisastra:": 11,
    "Wiktionary:": 11,
  };

  for (var entry in prefixes.entries) {
    if (title.startsWith(entry.key)) {
      if (title.length > entry.value) {
        return title.substring(entry.value).trim();
      } else {
        return title;
      }
    }
  }
  return title.trim();
}
