import 'package:dongsoop/domain/entites/home/notice_entity.dart';
import 'package:dongsoop/domain/usecases/home/notice_usecase.dart';
import 'package:dongsoop/presentation/home/viewmodels/providers/notice_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 홈 화면에서 공지 데이터를 관리하는 ViewModel의 Provider
/// 상태 타입은 비동기 데이터 상태를 나타내는 AsyncValue<List<NoticeEntity>>
final noticeViewModelProvider =
    StateNotifierProvider<NoticeViewModel, AsyncValue<List<NoticeEntity>>>(
  (ref) => NoticeViewModel(ref.watch(noticeUseCaseProvider)),
);

/// 홈 화면용 ViewModel
/// 공지 데이터를 비동기로 가져와 상태를 관리
/// 최신 공지 3개만 보여주는 용도로 사용
class NoticeViewModel extends StateNotifier<AsyncValue<List<NoticeEntity>>> {
  final NoticeUseCase useCase;

  /// 생성자에서 UseCase를 주입받고, 초기 상태는 로딩으로 설정
  /// 생성 직후 fetchNotices() 호출하여 데이터 요청
  NoticeViewModel(this.useCase) : super(const AsyncLoading()) {
    fetchNotices();
  }

  /// 공지 데이터를 가져오는 비동기 메서드
  /// 성공 시 AsyncValue.data 상태로 업데이트
  /// 실패 시 AsyncValue.error 상태로 에러와 스택트레이스(에러가 발생한 위치와 경로를 추적하는 로그)를 전달
  Future<void> fetchNotices() async {
    try {
      final notices = await useCase(page: 0);
      state = AsyncValue.data(notices);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
