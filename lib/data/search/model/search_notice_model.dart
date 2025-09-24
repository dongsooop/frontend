import 'package:dongsoop/domain/search/entity/search_notice_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_notice_model.freezed.dart';
part 'search_notice_model.g.dart';

@freezed
@JsonSerializable()
class SearchNoticeModel with _$SearchNoticeModel {
  final int boardId;
  final String title;
  final String authorName;
  final DateTime createdAt;
  final String noticeUrl;

  SearchNoticeModel({
    required this.boardId,
    required this.title,
    required this.authorName,
    required this.createdAt,
    required this.noticeUrl,
  });

  factory SearchNoticeModel.fromJson(Map<String, dynamic> json) => _$SearchNoticeModelFromJson(json);
}

extension SearchNoticeModelMapper on SearchNoticeModel {
  SearchNoticeEntity toEntity({required bool isDepartment}) {
    return SearchNoticeEntity(
      id: boardId,
      title: title,
      authorName: authorName,
      createdAt: createdAt,
      url: noticeUrl,
      isDepartment: isDepartment,
    );
  }
}