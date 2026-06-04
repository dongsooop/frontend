// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'restaurants_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RestaurantsRequest {
  String get externalMapId;
  String get name;
  String get placeUrl;
  String get distance;
  RestaurantsCategory get category;
  List<RestaurantsTag>? get tags;

  /// Create a copy of RestaurantsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RestaurantsRequestCopyWith<RestaurantsRequest> get copyWith =>
      _$RestaurantsRequestCopyWithImpl<RestaurantsRequest>(
          this as RestaurantsRequest, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RestaurantsRequest &&
            (identical(other.externalMapId, externalMapId) ||
                other.externalMapId == externalMapId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.placeUrl, placeUrl) ||
                other.placeUrl == placeUrl) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other.tags, tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, externalMapId, name, placeUrl,
      distance, category, const DeepCollectionEquality().hash(tags));

  @override
  String toString() {
    return 'RestaurantsRequest(externalMapId: $externalMapId, name: $name, placeUrl: $placeUrl, distance: $distance, category: $category, tags: $tags)';
  }
}

/// @nodoc
abstract mixin class $RestaurantsRequestCopyWith<$Res> {
  factory $RestaurantsRequestCopyWith(
          RestaurantsRequest value, $Res Function(RestaurantsRequest) _then) =
      _$RestaurantsRequestCopyWithImpl;
  @useResult
  $Res call(
      {String externalMapId,
      String name,
      String placeUrl,
      String distance,
      RestaurantsCategory category,
      List<RestaurantsTag>? tags});
}

/// @nodoc
class _$RestaurantsRequestCopyWithImpl<$Res>
    implements $RestaurantsRequestCopyWith<$Res> {
  _$RestaurantsRequestCopyWithImpl(this._self, this._then);

  final RestaurantsRequest _self;
  final $Res Function(RestaurantsRequest) _then;

  /// Create a copy of RestaurantsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? externalMapId = null,
    Object? name = null,
    Object? placeUrl = null,
    Object? distance = null,
    Object? category = null,
    Object? tags = freezed,
  }) {
    return _then(RestaurantsRequest(
      externalMapId: null == externalMapId
          ? _self.externalMapId
          : externalMapId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      placeUrl: null == placeUrl
          ? _self.placeUrl
          : placeUrl // ignore: cast_nullable_to_non_nullable
              as String,
      distance: null == distance
          ? _self.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as RestaurantsCategory,
      tags: freezed == tags
          ? _self.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<RestaurantsTag>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RestaurantsRequest].
extension RestaurantsRequestPatterns on RestaurantsRequest {
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
