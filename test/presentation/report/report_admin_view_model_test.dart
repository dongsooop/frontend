import 'dart:async';

import 'package:dongsoop/domain/report/enum/report_admin_filter.dart';
import 'package:dongsoop/domain/report/model/blind_date_report_request.dart';
import 'package:dongsoop/domain/report/model/chat_report_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import 'package:dongsoop/domain/report/model/report_sanction_response.dart';
import 'package:dongsoop/domain/report/repository/report_repository.dart';
import 'package:dongsoop/domain/report/use_case/get_reports_use_case.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReportAdminViewModel', () {
    test('선택한 필터의 API 값과 정렬 조건으로 첫 페이지를 조회한다', () async {
      final repository = _FakeReportRepository()
        ..responses.add(() async => [_report(1)]);
      final viewModel = _viewModel(repository);

      await viewModel.loadReports(filter: ReportAdminFilter.activeSanctions);

      expect(repository.calls, hasLength(1));
      expect(repository.calls.single.type, 'ACTIVE_SANCTIONS');
      expect(repository.calls.single.sort, 'createdAt,desc');
      expect(repository.calls.single.page, 0);
      expect(repository.calls.single.size, 10);
      expect(viewModel.state.filter, ReportAdminFilter.activeSanctions);
      expect(viewModel.state.reports.single.id, 1);
      expect(viewModel.state.isInitialLoading, isFalse);
    });

    test('다음 페이지 로딩 중 기존 목록을 유지하고 중복 신고를 제거한다', () async {
      final nextPage = Completer<List<ReportAdminSanction>?>();
      final repository = _FakeReportRepository()
        ..responses.add(
          () async => List.generate(10, (index) => _report(index + 1)),
        )
        ..responses.add(() => nextPage.future);
      final viewModel = _viewModel(repository);
      await viewModel.loadReports();

      final loading = viewModel.fetchNextPage();

      expect(viewModel.state.isInitialLoading, isFalse);
      expect(viewModel.state.isLoadingMore, isTrue);
      expect(viewModel.state.reports, hasLength(10));

      nextPage.complete([_report(10), _report(11)]);
      await loading;

      expect(viewModel.state.reports, hasLength(11));
      expect(viewModel.state.reports.last.id, 11);
      expect(viewModel.state.page, 1);
      expect(viewModel.state.hasNext, isFalse);
      expect(viewModel.state.isLoadingMore, isFalse);
    });

    test('빠르게 필터를 바꾸면 이전 필터의 늦은 응답을 무시한다', () async {
      final unprocessed = Completer<List<ReportAdminSanction>?>();
      final processed = Completer<List<ReportAdminSanction>?>();
      final repository = _FakeReportRepository()
        ..responses.add(() => unprocessed.future)
        ..responses.add(() => processed.future);
      final viewModel = _viewModel(repository);

      final firstLoad = viewModel.loadReports();
      final secondLoad = viewModel.loadReports(
        filter: ReportAdminFilter.processed,
      );
      processed.complete([_report(2, isProcessed: true)]);
      await secondLoad;
      unprocessed.complete([_report(1)]);
      await firstLoad;

      expect(viewModel.state.filter, ReportAdminFilter.processed);
      expect(viewModel.state.reports.single.id, 2);
    });

    test('당겨서 새로고치는 동안 기존 목록을 유지한다', () async {
      final refreshed = Completer<List<ReportAdminSanction>?>();
      final repository = _FakeReportRepository()
        ..responses.add(() async => [_report(1)])
        ..responses.add(() => refreshed.future);
      final viewModel = _viewModel(repository);
      await viewModel.loadReports();

      final refresh = viewModel.refresh();

      expect(viewModel.state.isRefreshing, isTrue);
      expect(viewModel.state.reports.single.id, 1);

      refreshed.complete([_report(2)]);
      await refresh;

      expect(viewModel.state.isRefreshing, isFalse);
      expect(viewModel.state.reports.single.id, 2);
      expect(viewModel.state.page, 0);
    });

    test('첫 조회 오류와 다음 페이지 오류를 서로 다른 상태로 보관한다', () async {
      final repository = _FakeReportRepository()
        ..responses.add(() async => throw StateError('initial failure'));
      final viewModel = _viewModel(repository);

      await viewModel.loadReports();

      expect(viewModel.state.errorMessage, isNotNull);
      expect(viewModel.state.reports, isEmpty);
      expect(viewModel.state.isInitialLoading, isFalse);

      repository.responses.add(
        () async => List.generate(10, (index) => _report(index + 1)),
      );
      repository.responses.add(() async => throw StateError('page failure'));
      await viewModel.loadReports();
      await viewModel.fetchNextPage();

      expect(viewModel.state.errorMessage, isNull);
      expect(viewModel.state.loadMoreErrorMessage, isNotNull);
      expect(viewModel.state.reports, hasLength(10));
      expect(viewModel.state.isLoadingMore, isFalse);
    });
  });
}

ReportAdminViewModel _viewModel(_FakeReportRepository repository) {
  return ReportAdminViewModel(GetReportsUseCase(repository));
}

ReportAdminSanction _report(int id, {bool isProcessed = false}) {
  return ReportAdminSanction(
    id: id,
    reporterNickname: '신고자$id',
    reportType: 'CHAT_MESSAGE',
    targetMemberId: 100 + id,
    targetMemberNickname: '대상$id',
    reportReason: 'SPAM',
    isProcessed: isProcessed,
    messageContent: '신고 메시지 $id',
    createdAt: '2026.10.15 10:00',
  );
}

typedef _ReportResponse = Future<List<ReportAdminSanction>?> Function();

class _ReportCall {
  final String type;
  final String sort;
  final int page;
  final int size;

  const _ReportCall({
    required this.type,
    required this.sort,
    required this.page,
    required this.size,
  });
}

class _FakeReportRepository implements ReportRepository {
  final List<_ReportCall> calls = [];
  final List<_ReportResponse> responses = [];

  @override
  Future<List<ReportAdminSanction>?> getReports(
    String type,
    String sort, {
    int page = 0,
    int size = 10,
  }) {
    calls.add(_ReportCall(type: type, sort: sort, page: page, size: size));
    return responses.removeAt(0)();
  }

  @override
  Future<ReportSanctionResponse?> getSanctionStatus() {
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
