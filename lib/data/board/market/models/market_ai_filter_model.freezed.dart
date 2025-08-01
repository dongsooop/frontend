// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_ai_filter_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarketAIFilterModel {
  String get text;

  /// Create a copy of MarketAIFilterModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MarketAIFilterModelCopyWith<MarketAIFilterModel> get copyWith =>
      _$MarketAIFilterModelCopyWithImpl<MarketAIFilterModel>(
          this as MarketAIFilterModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MarketAIFilterModel &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(runtimeType, text);

  @override
  String toString() {
    return 'MarketAIFilterModel(text: $text)';
  }
}

/// @nodoc
abstract mixin class $MarketAIFilterModelCopyWith<$Res> {
  factory $MarketAIFilterModelCopyWith(
          MarketAIFilterModel value, $Res Function(MarketAIFilterModel) _then) =
      _$MarketAIFilterModelCopyWithImpl;
  @useResult
  $Res call({String text});
}

/// @nodoc
class _$MarketAIFilterModelCopyWithImpl<$Res>
    implements $MarketAIFilterModelCopyWith<$Res> {
  _$MarketAIFilterModelCopyWithImpl(this._self, this._then);

  final MarketAIFilterModel _self;
  final $Res Function(MarketAIFilterModel) _then;

  /// Create a copy of MarketAIFilterModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
  }) {
    return _then(MarketAIFilterModel(
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
