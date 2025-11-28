// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'restaurants_kakao_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RestaurantsKakaoInfo {
  String get id;
  String get place_name;
  String get road_address_name;
  String get place_url;
  String get distance;

  /// Create a copy of RestaurantsKakaoInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RestaurantsKakaoInfoCopyWith<RestaurantsKakaoInfo> get copyWith =>
      _$RestaurantsKakaoInfoCopyWithImpl<RestaurantsKakaoInfo>(
          this as RestaurantsKakaoInfo, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RestaurantsKakaoInfo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.place_name, place_name) ||
                other.place_name == place_name) &&
            (identical(other.road_address_name, road_address_name) ||
                other.road_address_name == road_address_name) &&
            (identical(other.place_url, place_url) ||
                other.place_url == place_url) &&
            (identical(other.distance, distance) ||
                other.distance == distance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, place_name, road_address_name, place_url, distance);

  @override
  String toString() {
    return 'RestaurantsKakaoInfo(id: $id, place_name: $place_name, road_address_name: $road_address_name, place_url: $place_url, distance: $distance)';
  }
}

/// @nodoc
abstract mixin class $RestaurantsKakaoInfoCopyWith<$Res> {
  factory $RestaurantsKakaoInfoCopyWith(RestaurantsKakaoInfo value,
          $Res Function(RestaurantsKakaoInfo) _then) =
      _$RestaurantsKakaoInfoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String place_name,
      String road_address_name,
      String place_url,
      String distance});
}

/// @nodoc
class _$RestaurantsKakaoInfoCopyWithImpl<$Res>
    implements $RestaurantsKakaoInfoCopyWith<$Res> {
  _$RestaurantsKakaoInfoCopyWithImpl(this._self, this._then);

  final RestaurantsKakaoInfo _self;
  final $Res Function(RestaurantsKakaoInfo) _then;

  /// Create a copy of RestaurantsKakaoInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? place_name = null,
    Object? road_address_name = null,
    Object? place_url = null,
    Object? distance = null,
  }) {
    return _then(RestaurantsKakaoInfo(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      place_name: null == place_name
          ? _self.place_name
          : place_name // ignore: cast_nullable_to_non_nullable
              as String,
      road_address_name: null == road_address_name
          ? _self.road_address_name
          : road_address_name // ignore: cast_nullable_to_non_nullable
              as String,
      place_url: null == place_url
          ? _self.place_url
          : place_url // ignore: cast_nullable_to_non_nullable
              as String,
      distance: null == distance
          ? _self.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [RestaurantsKakaoInfo].
extension RestaurantsKakaoInfoPatterns on RestaurantsKakaoInfo {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        return null;
    }
  }
}

// dart format on
