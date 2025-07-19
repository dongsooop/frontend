// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mypage_recruit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MypageRecruit {
  int get id;
  String get title;
  String get content;
  List<String> get tags;
  List<String> get departmentTypeList;
  RecruitType get boardType;
  DateTime get startAt;
  DateTime get endAt;
  DateTime get createdAt;
  int get volunteer;
  bool get isRecruiting;

  /// Create a copy of MypageRecruit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MypageRecruitCopyWith<MypageRecruit> get copyWith =>
      _$MypageRecruitCopyWithImpl<MypageRecruit>(
          this as MypageRecruit, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MypageRecruit &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other.tags, tags) &&
            const DeepCollectionEquality()
                .equals(other.departmentTypeList, departmentTypeList) &&
            (identical(other.boardType, boardType) ||
                other.boardType == boardType) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.volunteer, volunteer) ||
                other.volunteer == volunteer) &&
            (identical(other.isRecruiting, isRecruiting) ||
                other.isRecruiting == isRecruiting));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      content,
      const DeepCollectionEquality().hash(tags),
      const DeepCollectionEquality().hash(departmentTypeList),
      boardType,
      startAt,
      endAt,
      createdAt,
      volunteer,
      isRecruiting);

  @override
  String toString() {
    return 'MypageRecruit(id: $id, title: $title, content: $content, tags: $tags, departmentTypeList: $departmentTypeList, boardType: $boardType, startAt: $startAt, endAt: $endAt, createdAt: $createdAt, volunteer: $volunteer, isRecruiting: $isRecruiting)';
  }
}

/// @nodoc
abstract mixin class $MypageRecruitCopyWith<$Res> {
  factory $MypageRecruitCopyWith(
          MypageRecruit value, $Res Function(MypageRecruit) _then) =
      _$MypageRecruitCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String title,
      String content,
      List<String> tags,
      List<String> departmentTypeList,
      RecruitType boardType,
      DateTime startAt,
      DateTime endAt,
      DateTime createdAt,
      int volunteer,
      bool isRecruiting});
}

/// @nodoc
class _$MypageRecruitCopyWithImpl<$Res>
    implements $MypageRecruitCopyWith<$Res> {
  _$MypageRecruitCopyWithImpl(this._self, this._then);

  final MypageRecruit _self;
  final $Res Function(MypageRecruit) _then;

  /// Create a copy of MypageRecruit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? tags = null,
    Object? departmentTypeList = null,
    Object? boardType = null,
    Object? startAt = null,
    Object? endAt = null,
    Object? createdAt = null,
    Object? volunteer = null,
    Object? isRecruiting = null,
  }) {
    return _then(MypageRecruit(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
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
              as List<String>,
      departmentTypeList: null == departmentTypeList
          ? _self.departmentTypeList
          : departmentTypeList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      boardType: null == boardType
          ? _self.boardType
          : boardType // ignore: cast_nullable_to_non_nullable
              as RecruitType,
      startAt: null == startAt
          ? _self.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endAt: null == endAt
          ? _self.endAt
          : endAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      volunteer: null == volunteer
          ? _self.volunteer
          : volunteer // ignore: cast_nullable_to_non_nullable
              as int,
      isRecruiting: null == isRecruiting
          ? _self.isRecruiting
          : isRecruiting // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
