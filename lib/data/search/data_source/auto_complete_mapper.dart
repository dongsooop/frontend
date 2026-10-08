class AutoCompleteMapper {
  static List<String> parseKeywordList(dynamic json) {
    if (json is List) return json.map((e) => e.toString()).toList();
    throw const FormatException('Expected List<String> for keyword list response');
  }
}
