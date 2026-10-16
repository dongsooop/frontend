import 'dart:async';

import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/report/enum/report_chat_room_type.dart';
import 'package:dongsoop/domain/report/enum/sanction_type.dart';
import 'package:dongsoop/domain/report/model/blind_date_report_request.dart';
import 'package:dongsoop/domain/report/model/chat_report_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import 'package:dongsoop/domain/report/model/report_sanction_response.dart';
import 'package:dongsoop/domain/report/repository/report_repository.dart';
import 'package:dongsoop/domain/report/use_case/report_admin_sanction_write_use_case.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_sanction_state.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_sanction_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 10, 15, 12);

  group('ReportAdminSanctionViewModel', () {
    test('경고는 사유를 필수로 요구하고 종료 시각 없이 제출한다', () async {
      final repository = _FakeReportRepository();
      final viewModel = _viewModel(repository, now);

      viewModel.selectSanctionType(SanctionType.WARNING);

      expect(viewModel.canSubmit, isFalse);

      viewModel.updateSanctionReason('반복적인 욕설');

      expect(viewModel.canSubmit, isTrue);
      expect(
        await viewModel.sanctionWrite(reportId: 101, targetMemberId: 42),
        isTrue,
      );
      expect(repository.request?.sanctionType, SanctionType.WARNING);
      expect(repository.request?.sanctionReason, '반복적인 욕설');
      expect(repository.request?.sanctionEndAt, isNull);
    });

    test('공백으로만 작성한 경고 사유는 제출할 수 없다', () {
      final viewModel = _viewModel(_FakeReportRepository(), now);
      viewModel.selectSanctionType(SanctionType.WARNING);
      viewModel.updateSanctionReason('   ');

      expect(viewModel.canSubmit, isFalse);
    });

    test('일시정지는 미래 종료 시각을 필수로 요구하고 초를 제거한다', () {
      final viewModel = _viewModel(_FakeReportRepository(), now);
      viewModel.selectSanctionType(SanctionType.TEMPORARY_BAN);

      expect(viewModel.canSubmit, isFalse);

      viewModel.selectSanctionEndAt(
        DateTime(2026, 10, 15, 11, 59, 42),
      );
      expect(viewModel.canSubmit, isFalse);

      viewModel.selectSanctionEndAt(
        DateTime(2026, 10, 16, 12, 30, 42),
      );
      expect(viewModel.canSubmit, isTrue);
      expect(viewModel.state.sanctionEndAt, DateTime(2026, 10, 16, 12, 30));
    });

    test('일시정지에서 영구정지로 바꾸면 종료 시각을 제거한다', () {
      final viewModel = _viewModel(_FakeReportRepository(), now);
      viewModel.selectSanctionType(SanctionType.TEMPORARY_BAN);
      viewModel.selectSanctionEndAt(DateTime(2026, 10, 16));

      viewModel.selectSanctionType(SanctionType.PERMANENT_BAN);

      expect(viewModel.state.sanctionEndAt, isNull);
      expect(viewModel.canSubmit, isTrue);
    });

    group('채팅방 추방', () {
      test('단체 채팅과 과팅에서 선택할 수 있다', () {
        for (final roomType in [
          ReportChatRoomType.GROUP,
          ReportChatRoomType.BLINDDATE,
        ]) {
          final viewModel = _viewModel(
            _FakeReportRepository(),
            now,
            chatRoomType: roomType,
          );

          viewModel.selectSanctionType(SanctionType.CHAT_KICK);

          expect(viewModel.state.sanctionType, SanctionType.CHAT_KICK);
          expect(viewModel.canSubmit, isTrue);
          expect(
            viewModel.availableSanctions,
            contains(SanctionType.CHAT_KICK),
          );
        }
      });

      test('1:1, 문의, 구형 신고에서는 선택할 수 없다', () {
        for (final roomType in [
          ReportChatRoomType.ONE_TO_ONE,
          ReportChatRoomType.CONTACT,
          ReportChatRoomType.UNKNOWN,
          null,
        ]) {
          final viewModel = _viewModel(
            _FakeReportRepository(),
            now,
            chatRoomType: roomType,
          );

          viewModel.selectSanctionType(SanctionType.CHAT_KICK);

          expect(viewModel.state.sanctionType, isNull);
          expect(viewModel.canSubmit, isFalse);
          expect(
            viewModel.availableSanctions,
            isNot(contains(SanctionType.CHAT_KICK)),
          );
        }
      });
    });

    test('제재 사유의 앞뒤 공백을 제거해 요청한다', () async {
      final repository = _FakeReportRepository();
      final viewModel = _viewModel(repository, now);
      viewModel.selectSanctionType(SanctionType.WARNING);
      viewModel.updateSanctionReason('  반복적인 욕설  ');

      await viewModel.sanctionWrite(reportId: 101, targetMemberId: 42);

      expect(repository.request?.sanctionReason, '반복적인 욕설');
    });

    test('제출 중 중복 요청을 차단한다', () async {
      final pending = Completer<void>();
      final repository = _FakeReportRepository()..pending = pending;
      final viewModel = _viewModel(repository, now);
      viewModel.selectSanctionType(SanctionType.WARNING);
      viewModel.updateSanctionReason('반복적인 욕설');

      final first = viewModel.sanctionWrite(
        reportId: 101,
        targetMemberId: 42,
      );
      final second = await viewModel.sanctionWrite(
        reportId: 101,
        targetMemberId: 42,
      );

      expect(second, isFalse);
      expect(repository.callCount, 1);
      expect(viewModel.state.isSubmitting, isTrue);

      pending.complete();
      expect(await first, isTrue);
      expect(viewModel.state.isSubmitting, isFalse);
    });

    test('이미 처리된 신고 오류를 목록 갱신이 필요한 실패로 구분한다', () async {
      final repository = _FakeReportRepository()
        ..error = const AlreadyProcessedException('이미 처리된 신고입니다. ID : 101');
      final viewModel = _viewModel(repository, now);
      viewModel.selectSanctionType(SanctionType.WARNING);
      viewModel.updateSanctionReason('반복적인 욕설');

      final success = await viewModel.sanctionWrite(
        reportId: 101,
        targetMemberId: 42,
      );

      expect(success, isFalse);
      expect(
        viewModel.state.failure,
        ReportAdminSanctionFailure.alreadyProcessed,
      );
      expect(viewModel.state.errorMessage, '이미 처리된 신고입니다. ID : 101');
    });
  });
}

ReportAdminSanctionViewModel _viewModel(
  _FakeReportRepository repository,
  DateTime now, {
  ReportChatRoomType? chatRoomType,
}) {
  return ReportAdminSanctionViewModel(
    ReportAdminSanctionWriteUseCase(repository),
    chatRoomType: chatRoomType,
    now: () => now,
  );
}

class _FakeReportRepository implements ReportRepository {
  ReportAdminSanctionRequest? request;
  Object? error;
  Completer<void>? pending;
  int callCount = 0;

  @override
  Future<void> dismissReport(int reportId) {
    throw UnimplementedError();
  }

  @override
  Future<void> sanctionWriteReport(ReportAdminSanctionRequest request) async {
    callCount += 1;
    this.request = request;
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
}
