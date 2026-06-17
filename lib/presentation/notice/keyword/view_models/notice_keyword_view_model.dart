import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/notice/keyword/enum/notice_keyword_type.dart';
import 'package:dongsoop/domain/notice/keyword/use_cases/add_notice_keyword_use_case.dart';
import 'package:dongsoop/domain/notice/keyword/use_cases/delete_notice_keyword_use_case.dart';
import 'package:dongsoop/domain/notice/keyword/use_cases/get_notice_keywords_use_case.dart';
import 'package:dongsoop/presentation/notice/keyword/view_models/notice_keyword_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoticeKeywordViewModel extends StateNotifier<NoticeKeywordState> {
  final GetNoticeKeywordsUseCase _getKeywords;
  final AddNoticeKeywordUseCase _addKeyword;
  final DeleteNoticeKeywordUseCase _deleteKeyword;

  NoticeKeywordViewModel(
    this._getKeywords,
    this._addKeyword,
    this._deleteKeyword,
  ) : super(const NoticeKeywordState());

  Future<void> loadKeywords() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final keywords = await _getKeywords.execute();
      state = state.copyWith(keywords: keywords, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> addKeyword(String keyword, NoticeKeywordType type) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final added = await _addKeyword.execute(keyword: keyword, type: type);
      state = state.copyWith(
        keywords: [...state.keywords, added],
        isLoading: false,
      );
    } on DuplicateNoticeKeywordException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> deleteKeyword(int keywordId) async {
    try {
      await _deleteKeyword.execute(keywordId);
      state = state.copyWith(
        keywords: state.keywords.where((k) => k.id != keywordId).toList(),
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
