import 'package:dongsoop/domain/notice/entites/notice_entity.dart';
import 'package:dongsoop/domain/notice/use_cases/notice_use_case.dart';
import 'package:dongsoop/presentation/home/providers/notice_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final noticeViewModelProvider =
    StateNotifierProvider<NoticeViewModel, AsyncValue<List<NoticeEntity>>>(
  (ref) => NoticeViewModel(ref.watch(noticeUseCaseProvider)),
);

class NoticeViewModel extends StateNotifier<AsyncValue<List<NoticeEntity>>> {
  final NoticeUseCase useCase;

  NoticeViewModel(this.useCase) : super(const AsyncLoading()) {
    fetchNotices(force: true); // 앱 실행 시 무조건 한 번 요청
  }

  // 하루 기준 요청 허용 시각 (10:10 / 14:10 / 18:10)
  List<DateTime> get _fetchTimeWindows {
    final now = DateTime.now();
    return [
      DateTime(now.year, now.month, now.day, 10, 10),
      DateTime(now.year, now.month, now.day, 14, 10),
      DateTime(now.year, now.month, now.day, 18, 10),
    ];
  }

  // 이전 요청 시각 기준으로 이번 요청이 허용되는지 판단
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

  /// 서버에서 공지 3개 받아오거나 캐시 확인
  Future<void> fetchNotices({bool force = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final hasFetchedOnce = prefs.getBool('notice_fetched_once') ?? false;
      final lastTimeStr = prefs.getString('notice_last_fetched_time');
      final lastFetchedTime =
          lastTimeStr != null ? DateTime.tryParse(lastTimeStr) : null;

      final needFetch =
          force || !hasFetchedOnce || _isNeedToFetch(lastFetchedTime);

      if (needFetch) {
        final notices = await useCase(
          page: 0,
          tab: NoticeTab.all,
          departmentType: null,
        );

        final top3 = notices.take(3).toList();
        state = AsyncValue.data(top3);

        await prefs.setString(
          'notice_last_fetched_time',
          DateTime.now().toIso8601String(),
        );
        await prefs.setBool('notice_fetched_once', true);
      } else {
        // 조건 안 맞는 경우, 이전 데이터가 없다면 빈 리스트라도(임시)
        if (state is! AsyncData) {
          state = const AsyncValue.data([]);
        }
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
