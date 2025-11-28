import 'dart:async';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/restaurants/use_case/search_kakao_use_case.dart';
import 'package:dongsoop/presentation/restaurants/write/search_kakao_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchKakaoViewModel extends StateNotifier<SearchKakaoState>{
  final SearchKakaoUseCase _searchKakaoUseCase;

  SearchKakaoViewModel(
    this._searchKakaoUseCase,
  ) : super(
    SearchKakaoState(isLoading: false)
  );

  Timer? _debounce;
  String _lastInput = ''; // 마지막으로 입력된 값
  String _lastCompletedQuery = ''; // 마지막으로 "성공적으로" 요청한 값
  int _requestId = 0; // 요청 식별자 (오래된 응답 무시용)

  void searchByKakao(String search) {
    // 입력이 아예 안 바뀌었으면 무시
    if (_lastInput == search) return;
    _lastInput = search;

    // 공백이면 상태 초기화 후 종료
    if (search.isEmpty) {
      _debounce?.cancel();
      state = state.copyWith(
        result: [],  // 결과 리스트가 있다면 같이 초기화
        errorMessage: null,
      );
      return;
    }

    // 이전 타이머 취소하고 새로 시작 (300ms 디바운스)
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      // 디바운스가 끝난 시점에서도, 이미 같은 검색어로 성공한 적 있으면 또 요청 안 함
      if (_lastCompletedQuery == _lastInput) return;

      _performSearch(_lastInput);
    });
  }

  Future<void> _performSearch(String query) async {
    final currentId = ++_requestId;

    state = state.copyWith(
      errorMessage: null,
    );

    try {
      final result = await _searchKakaoUseCase.execute(query);

      // 응답이 왔을 때, 그 사이에 더 최근 요청이 생겼으면 이 응답은 버린다
      if (currentId != _requestId) return;

      _lastCompletedQuery = query;

      state = state.copyWith(
        result: result,
        errorMessage: null,
      );
    } on KaKaoSearchException catch (e) {
      if (currentId != _requestId) return;

      state = state.copyWith(
        errorMessage: e.message,
      );
    } catch (e) {
      if (currentId != _requestId) return;

      state = state.copyWith(
        errorMessage: '검색 중 오류가 발생했습니다.\n잠시 후에 다시 시도해 주세요',
      );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}