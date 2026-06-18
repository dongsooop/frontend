import 'package:dongsoop/domain/notice/keyword/entity/notice_keyword_entity.dart';
import 'package:dongsoop/domain/notice/keyword/enum/notice_keyword_type.dart';

class NoticeKeywordState {
  final List<NoticeKeywordEntity> keywords;
  final bool isLoading;
  final String? errorMessage;

  const NoticeKeywordState({
    this.keywords = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  List<NoticeKeywordEntity> get includeKeywords =>
      keywords.where((k) => k.type == NoticeKeywordType.include).toList();

  List<NoticeKeywordEntity> get excludeKeywords =>
      keywords.where((k) => k.type == NoticeKeywordType.exclude).toList();

  NoticeKeywordState copyWith({
    List<NoticeKeywordEntity>? keywords,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NoticeKeywordState(
      keywords: keywords ?? this.keywords,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
