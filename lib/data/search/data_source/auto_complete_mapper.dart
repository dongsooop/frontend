import 'package:dongsoop/domain/search/enum/board_type.dart';

class AutoCompleteMapper {
  static String toApiBoardType(SearchBoardType type) {
    switch (type) {
      case SearchBoardType.recruit:
        return 'RECRUIT';
      case SearchBoardType.market:
        return 'MARKETPLACE';
      case SearchBoardType.notice:
        return 'NOTICE';
    }
  }

  static List<String> parseKeywordList(dynamic json) {
    if (json is List) return json.map((e) => e.toString()).toList();
    throw const FormatException('Expected List<String> for keyword list response');
  }
}