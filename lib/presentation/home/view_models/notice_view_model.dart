import 'package:dongsoop/domain/notice/entites/notice_entity.dart';
import 'package:dongsoop/domain/notice/use_cases/notice_usecase.dart';
import 'package:dongsoop/presentation/home/providers/notice_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 상태 타입은 비동기 데이터 상태를 나타내는 AsyncValue<List<NoticeEntity>>
final noticeViewModelProvider =
    StateNotifierProvider<NoticeViewModel, AsyncValue<List<NoticeEntity>>>(
  (ref) => NoticeViewModel(ref.watch(noticeUseCaseProvider)),
);

/// 최신 공지 3개만 보여주는 용도로 사용
class NoticeViewModel extends StateNotifier<AsyncValue<List<NoticeEntity>>> {
  final NoticeUseCase useCase;

  NoticeViewModel(this.useCase) : super(const AsyncLoading()) {
    fetchNotices();
  }

  /// 오늘 날짜 기준으로 시간대 계산
  List<DateTime> get _fetchTimeWindows {
    final now = DateTime.now();
    return [
      DateTime(now.year, now.month, now.day, 10, 10),
      DateTime(now.year, now.month, now.day, 14, 10),
      DateTime(now.year, now.month, now.day, 18, 10),
    ];
  }

  bool _hasFetchedOnce = false;

  bool _isNeedToFetch(DateTime? lastFetchedTime) {
    final now = DateTime.now();

    for (final time in _fetchTimeWindows) {
      if (lastFetchedTime == null && now.isAfter(time)) return true;
      if (lastFetchedTime != null &&
          lastFetchedTime.isBefore(time) &&
          now.isAfter(time)) return true;
    }
    return false;
  }

  Future<void> fetchNotices() async {
    if (_hasFetchedOnce) return; // 앱 내에서 다시 접근한 경우 무시(중복 서버 요청 방지)
    _hasFetchedOnce = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final lastTimeStr = prefs.getString('notice_last_fetched_time');
      final lastFetchedTime =
          lastTimeStr != null ? DateTime.tryParse(lastTimeStr) : null;

      if (!_isNeedToFetch(lastFetchedTime)) {
        print('해당 시간대 x');
        return;
      }

      final notices = await useCase(page: 0);
      final top3 = notices.take(3).toList();

      state = AsyncValue.data(top3);
      // 마지막 요청 시간 저장
      prefs.setString(
        'notice_last_fetched_time',
        DateTime.now().toIso8601String(),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
