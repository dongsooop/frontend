// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blind_date_open_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlindDateOpenRequest {
  DateTime get expiredDate;
  int get maxSessionMemberCount;

  /// Create a copy of BlindDateOpenRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BlindDateOpenRequestCopyWith<BlindDateOpenRequest> get copyWith =>
      _$BlindDateOpenRequestCopyWithImpl<BlindDateOpenRequest>(
          this as BlindDateOpenRequest, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BlindDateOpenRequest &&
            (identical(other.expiredDate, expiredDate) ||
                other.expiredDate == expiredDate) &&
            (identical(other.maxSessionMemberCount, maxSessionMemberCount) ||
                other.maxSessionMemberCount == maxSessionMemberCount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, expiredDate, maxSessionMemberCount);

  @override
  String toString() {
    return 'BlindDateOpenRequest(expiredDate: $expiredDate, maxSessionMemberCount: $maxSessionMemberCount)';
  }
}

/// @nodoc
abstract mixin class $BlindDateOpenRequestCopyWith<$Res> {
  factory $BlindDateOpenRequestCopyWith(BlindDateOpenRequest value,
          $Res Function(BlindDateOpenRequest) _then) =
      _$BlindDateOpenRequestCopyWithImpl;
  @useResult
  $Res call({DateTime expiredDate, int maxSessionMemberCount});
}

/// @nodoc
class _$BlindDateOpenRequestCopyWithImpl<$Res>
    implements $BlindDateOpenRequestCopyWith<$Res> {
  _$BlindDateOpenRequestCopyWithImpl(this._self, this._then);

  final BlindDateOpenRequest _self;
  final $Res Function(BlindDateOpenRequest) _then;

  /// Create a copy of BlindDateOpenRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expiredDate = null,
    Object? maxSessionMemberCount = null,
  }) {
    return _then(BlindDateOpenRequest(
      expiredDate: null == expiredDate
          ? _self.expiredDate
          : expiredDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      maxSessionMemberCount: null == maxSessionMemberCount
          ? _self.maxSessionMemberCount
          : maxSessionMemberCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
