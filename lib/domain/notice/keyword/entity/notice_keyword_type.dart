enum NoticeKeywordType {
  include,
  exclude;

  String toJson() => name.toUpperCase();

  static NoticeKeywordType fromJson(String value) {
    return NoticeKeywordType.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
    );
  }
}
