import 'package:freezed_annotation/freezed_annotation.dart';

enum ReportChatRoomType {
  @JsonValue('ONE_TO_ONE')
  ONE_TO_ONE,
  @JsonValue('GROUP')
  GROUP,
  @JsonValue('CONTACT')
  CONTACT,
  @JsonValue('BLINDDATE')
  BLINDDATE,
  UNKNOWN,
}
