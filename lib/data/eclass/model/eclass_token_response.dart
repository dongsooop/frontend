import 'package:freezed_annotation/freezed_annotation.dart';

part 'eclass_token_response.freezed.dart';
part 'eclass_token_response.g.dart';

@freezed
@JsonSerializable(createToJson: false)
class EclassTokenResponse with _$EclassTokenResponse {
  final String token;

  EclassTokenResponse({
    required this.token,
  });

  factory EclassTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$EclassTokenResponseFromJson(json);
}
