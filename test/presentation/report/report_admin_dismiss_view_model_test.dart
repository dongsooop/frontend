import 'dart:async';

import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/report/model/blind_date_report_request.dart';
import 'package:dongsoop/domain/report/model/chat_report_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import 'package:dongsoop/domain/report/model/report_sanction_response.dart';
import 'package:dongsoop/domain/report/repository/report_repository.dart';
import 'package:dongsoop/domain/report/use_case/report_admin_dismiss_use_case.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_dismiss_state.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_dismiss_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReportAdminDismissViewModel', () {
    test('신고 ID를 전달하고 성공 결과를 반환한다', () async {
      final repository = _FakeReportRepository();
      final viewModel = _viewModel(repository);

      expect(await viewModel.dismiss(101), isTrue);
      expect(repository.reportIds, [101]);
      expect(viewModel.state.isSubmitting, isFalse);
      expect(viewModel.state.errorMessage, isNull);
    });

    test('처리 중 중복 요청을 차단한다', () async {
      final pending = Completer<void>();
      final repository = _FakeReportRepository()..pending = pending;
      final viewModel = _viewModel(repository);

      final first = viewModel.dismiss(101);
      final second = await viewModel.dismiss(101);

      expect(second, isFalse);
      expect(repository.reportIds, [101]);
      expect(viewModel.state.isSubmitting, isTrue);

      pending.complete();
      expect(await first, isTrue);
      expect(viewModel.state.isSubmitting, isFalse);
    });

    test('404와 409를 목록 갱신이 필요한 상태 변경으로 구분한다', () async {
      final notFoundRepository = _FakeReportRepository()
        ..error = const NotFoundSanctionException('존재하지 않는 신고입니다. ID : 101');
      final notFoundViewModel = _viewModel(notFoundRepository);

      expect(await notFoundViewModel.dismiss(101), isFalse);
      expect(
        notFoundViewModel.state.failure,
        ReportAdminDismissFailure.notFound,
      );
      expect(
        notFoundViewModel.state.errorMessage,
        '존재하지 않는 신고입니다. ID : 101',
      );

      final conflictRepository = _FakeReportRepository()
        ..error = const AlreadyProcessedException('이미 처리된 신고입니다. ID : 101');
      final conflictViewModel = _viewModel(conflictRepository);

      expect(await conflictViewModel.dismiss(101), isFalse);
      expect(
        conflictViewModel.state.failure,
        ReportAdminDismissFailure.alreadyProcessed,
      );
      expect(
        conflictViewModel.state.errorMessage,
        '이미 처리된 신고입니다. ID : 101',
      );
    });

    test('권한 오류 문구를 보존하고 상세 화면을 유지할 실패로 구분한다', () async {
      final repository = _FakeReportRepository()
        ..error = const NoAdminAuthorityException('관리자 권한이 없습니다.');
      final viewModel = _viewModel(repository);

      expect(await viewModel.dismiss(101), isFalse);
      expect(viewModel.state.failure, ReportAdminDismissFailure.forbidden);
      expect(viewModel.state.errorMessage, '관리자 권한이 없습니다.');
    });

    test('유효하지 않은 신고 ID는 저장소를 호출하지 않는다', () async {
      final repository = _FakeReportRepository();
      final viewModel = _viewModel(repository);

      expect(await viewModel.dismiss(0), isFalse);
      expect(repository.reportIds, isEmpty);
      expect(viewModel.state.errorMessage, '신고 정보를 다시 확인해 주세요.');
    });
  });
}

ReportAdminDismissViewModel _viewModel(_FakeReportRepository repository) {
  return ReportAdminDismissViewModel(ReportAdminDismissUseCase(repository));
}

class _FakeReportRepository implements ReportRepository {
  final List<int> reportIds = [];
  Object? error;
  Completer<void>? pending;

  @override
  Future<void> dismissReport(int reportId) async {
    reportIds.add(reportId);
    if (error case final Object submissionError) throw submissionError;
    await pending?.future;
  }

  @override
  Future<ReportSanctionResponse?> getSanctionStatus() {
    throw UnimplementedError();
  }

  @override
  Future<List<ReportAdminSanction>?> getReports(
    String type,
    String sort, {
    int page = 0,
    int size = 10,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> reportBlindDateMessage(BlindDateReportRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<void> reportChatMessage(ChatReportRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<void> sanctionWriteReport(ReportAdminSanctionRequest request) {
    throw UnimplementedError();
  }
}
