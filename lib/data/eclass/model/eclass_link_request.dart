import 'package:freezed_annotation/freezed_annotation.dart';

part 'eclass_link_request.freezed.dart';
part 'eclass_link_request.g.dart';

@freezed
@JsonSerializable()
class EclassLinkRequest with _$EclassLinkRequest {
  final String token;

  EclassLinkRequest({
    required this.token,
  });

  factory EclassLinkRequest.fromJson(Map<String, dynamic> json) =>
      _$EclassLinkRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EclassLinkRequestToJson(this);
}
