// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feedback_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedbackListResponse {
  List<FeatureCountModel> get serviceFeatures;
  List<String> get improvementSuggestions;
  List<String> get featureRequests;

  /// Create a copy of FeedbackListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedbackListResponseCopyWith<FeedbackListResponse> get copyWith =>
      _$FeedbackListResponseCopyWithImpl<FeedbackListResponse>(
          this as FeedbackListResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedbackListResponse &&
            const DeepCollectionEquality()
                .equals(other.serviceFeatures, serviceFeatures) &&
            const DeepCollectionEquality()
                .equals(other.improvementSuggestions, improvementSuggestions) &&
            const DeepCollectionEquality()
                .equals(other.featureRequests, featureRequests));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(serviceFeatures),
      const DeepCollectionEquality().hash(improvementSuggestions),
      const DeepCollectionEquality().hash(featureRequests));

  @override
  String toString() {
    return 'FeedbackListResponse(serviceFeatures: $serviceFeatures, improvementSuggestions: $improvementSuggestions, featureRequests: $featureRequests)';
  }
}

/// @nodoc
abstract mixin class $FeedbackListResponseCopyWith<$Res> {
  factory $FeedbackListResponseCopyWith(FeedbackListResponse value,
          $Res Function(FeedbackListResponse) _then) =
      _$FeedbackListResponseCopyWithImpl;
  @useResult
  $Res call(
      {List<FeatureCountModel> serviceFeatures,
      List<String> improvementSuggestions,
      List<String> featureRequests});
}

/// @nodoc
class _$FeedbackListResponseCopyWithImpl<$Res>
    implements $FeedbackListResponseCopyWith<$Res> {
  _$FeedbackListResponseCopyWithImpl(this._self, this._then);

  final FeedbackListResponse _self;
  final $Res Function(FeedbackListResponse) _then;

  /// Create a copy of FeedbackListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceFeatures = null,
    Object? improvementSuggestions = null,
    Object? featureRequests = null,
  }) {
    return _then(FeedbackListResponse(
      serviceFeatures: null == serviceFeatures
          ? _self.serviceFeatures
          : serviceFeatures // ignore: cast_nullable_to_non_nullable
              as List<FeatureCountModel>,
      improvementSuggestions: null == improvementSuggestions
          ? _self.improvementSuggestions
          : improvementSuggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      featureRequests: null == featureRequests
          ? _self.featureRequests
          : featureRequests // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [FeedbackListResponse].
extension FeedbackListResponsePatterns on FeedbackListResponse {
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
