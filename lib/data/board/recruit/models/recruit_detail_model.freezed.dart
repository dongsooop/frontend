// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recruit_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecruitDetailModel {
  int get id;
  int get authorId;
  int get volunteer;
  DateTime get startAt;
  DateTime get endAt;
  String get title;
  String get content;
  String get tags;
  List<String> get departmentTypeList;
  String get author;
  DateTime get createdAt;
  String get viewType;
  bool get isAlreadyApplied;

  /// Create a copy of RecruitDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecruitDetailModelCopyWith<RecruitDetailModel> get copyWith =>
      _$RecruitDetailModelCopyWithImpl<RecruitDetailModel>(
          this as RecruitDetailModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecruitDetailModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.volunteer, volunteer) ||
                other.volunteer == volunteer) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.tags, tags) || other.tags == tags) &&
            const DeepCollectionEquality()
                .equals(other.departmentTypeList, departmentTypeList) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.viewType, viewType) ||
                other.viewType == viewType) &&
            (identical(other.isAlreadyApplied, isAlreadyApplied) ||
                other.isAlreadyApplied == isAlreadyApplied));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      authorId,
      volunteer,
      startAt,
      endAt,
      title,
      content,
      tags,
      const DeepCollectionEquality().hash(departmentTypeList),
      author,
      createdAt,
      viewType,
      isAlreadyApplied);

  @override
  String toString() {
    return 'RecruitDetailModel(id: $id, authorId: $authorId, volunteer: $volunteer, startAt: $startAt, endAt: $endAt, title: $title, content: $content, tags: $tags, departmentTypeList: $departmentTypeList, author: $author, createdAt: $createdAt, viewType: $viewType, isAlreadyApplied: $isAlreadyApplied)';
  }
}

/// @nodoc
abstract mixin class $RecruitDetailModelCopyWith<$Res> {
  factory $RecruitDetailModelCopyWith(
          RecruitDetailModel value, $Res Function(RecruitDetailModel) _then) =
      _$RecruitDetailModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      int authorId,
      int volunteer,
      DateTime startAt,
      DateTime endAt,
      String title,
      String content,
      String tags,
      List<String> departmentTypeList,
      String author,
      DateTime createdAt,
      String viewType,
      bool isAlreadyApplied});
}

/// @nodoc
class _$RecruitDetailModelCopyWithImpl<$Res>
    implements $RecruitDetailModelCopyWith<$Res> {
  _$RecruitDetailModelCopyWithImpl(this._self, this._then);

  final RecruitDetailModel _self;
  final $Res Function(RecruitDetailModel) _then;

  /// Create a copy of RecruitDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorId = null,
    Object? volunteer = null,
    Object? startAt = null,
    Object? endAt = null,
    Object? title = null,
    Object? content = null,
    Object? tags = null,
    Object? departmentTypeList = null,
    Object? author = null,
    Object? createdAt = null,
    Object? viewType = null,
    Object? isAlreadyApplied = null,
  }) {
    return _then(RecruitDetailModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      authorId: null == authorId
          ? _self.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as int,
      volunteer: null == volunteer
          ? _self.volunteer
          : volunteer // ignore: cast_nullable_to_non_nullable
              as int,
      startAt: null == startAt
          ? _self.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endAt: null == endAt
          ? _self.endAt
          : endAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _self.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as String,
      departmentTypeList: null == departmentTypeList
          ? _self.departmentTypeList
          : departmentTypeList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      author: null == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      viewType: null == viewType
          ? _self.viewType
          : viewType // ignore: cast_nullable_to_non_nullable
              as String,
      isAlreadyApplied: null == isAlreadyApplied
          ? _self.isAlreadyApplied
          : isAlreadyApplied // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [RecruitDetailModel].
extension RecruitDetailModelPatterns on RecruitDetailModel {
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
