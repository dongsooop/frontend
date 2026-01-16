import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_state.freezed.dart';
part 'social_state.g.dart';

@freezed
@JsonSerializable()
class SocialState with _$SocialState {
  final String providerType;
  final DateTime createdAt;

  const SocialState({
    required this.providerType,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => _$SocialStateToJson(this);
  factory SocialState.fromJson(Map<String, dynamic> json) => _$SocialStateFromJson(json);
}