import 'package:dongsoop/domain/feedback/entity/feature_count_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feature_count_model.freezed.dart';
part 'feature_count_model.g.dart';

@freezed
@JsonSerializable()
class FeatureCountModel with _$FeatureCountModel {
  final String serviceFeatureName;
  final int count;

  FeatureCountModel({
    required this.serviceFeatureName,
    required this.count,
  });

  factory FeatureCountModel.fromJson(Map<String, dynamic> json) =>
      _$FeatureCountModelFromJson(json);
}

extension FeatureCountModelX on FeatureCountModel {
  FeedbackCountEntity toEntity() {
    return FeedbackCountEntity(
      serviceFeatureName: serviceFeatureName,
      count: count,
    );
  }
}