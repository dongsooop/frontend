import 'package:freezed_annotation/freezed_annotation.dart';

enum NoticeKeywordType {
  @JsonValue('INCLUDE')
  include,

  @JsonValue('EXCLUDE')
  exclude,
}
