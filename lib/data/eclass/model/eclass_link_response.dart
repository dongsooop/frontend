import 'package:freezed_annotation/freezed_annotation.dart';

part 'eclass_link_response.freezed.dart';
part 'eclass_link_response.g.dart';

@freezed
@JsonSerializable(createToJson: false)
class EclassLinkResponse with _$EclassLinkResponse {
  final bool linked;
  final String? status;
  final String? moodleFullname;
  final DateTime? lastSyncedAt;

  EclassLinkResponse({
    required this.linked,
    required this.status,
    required this.moodleFullname,
    required this.lastSyncedAt,
  });

  factory EclassLinkResponse.fromJson(Map<String, dynamic> json) =>
      _$EclassLinkResponseFromJson(json);
}
