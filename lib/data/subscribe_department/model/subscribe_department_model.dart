import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscribe_department_model.freezed.dart';
part 'subscribe_department_model.g.dart';

@freezed
@JsonSerializable()
class SubscribeDepartmentModel with _$SubscribeDepartmentModel {
  final List<String> departmentTypes;

  SubscribeDepartmentModel({
    required this.departmentTypes,
  });

  factory SubscribeDepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$SubscribeDepartmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubscribeDepartmentModelToJson(this);
}
