import 'package:freezed_annotation/freezed_annotation.dart';

part 'guest_department_model.freezed.dart';
part 'guest_department_model.g.dart';

@freezed
@JsonSerializable()
class GuestDepartmentModel with _$GuestDepartmentModel {
  final List<String> departmentTypes;

  GuestDepartmentModel({
    required this.departmentTypes,
  });

  factory GuestDepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$GuestDepartmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$GuestDepartmentModelToJson(this);
}
