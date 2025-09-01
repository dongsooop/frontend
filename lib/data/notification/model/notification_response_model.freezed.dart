// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationResponseModel {
  int get unreadCount;
  List<NotificationModel> get items;

  /// Create a copy of NotificationResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationResponseModelCopyWith<NotificationResponseModel> get copyWith =>
      _$NotificationResponseModelCopyWithImpl<NotificationResponseModel>(
          this as NotificationResponseModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationResponseModel &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            const DeepCollectionEquality().equals(other.items, items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, unreadCount, const DeepCollectionEquality().hash(items));

  @override
  String toString() {
    return 'NotificationResponseModel(unreadCount: $unreadCount, items: $items)';
  }
}

/// @nodoc
abstract mixin class $NotificationResponseModelCopyWith<$Res> {
  factory $NotificationResponseModelCopyWith(NotificationResponseModel value,
          $Res Function(NotificationResponseModel) _then) =
      _$NotificationResponseModelCopyWithImpl;
  @useResult
  $Res call({int unreadCount, List<NotificationModel> items});
}

/// @nodoc
class _$NotificationResponseModelCopyWithImpl<$Res>
    implements $NotificationResponseModelCopyWith<$Res> {
  _$NotificationResponseModelCopyWithImpl(this._self, this._then);

  final NotificationResponseModel _self;
  final $Res Function(NotificationResponseModel) _then;

  /// Create a copy of NotificationResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unreadCount = null,
    Object? items = null,
  }) {
    return _then(NotificationResponseModel(
      unreadCount: null == unreadCount
          ? _self.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<NotificationModel>,
    ));
  }
}

// dart format on
