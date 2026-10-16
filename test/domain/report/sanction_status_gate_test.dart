import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/auth/data_source/auth_data_source.dart';
import 'package:dongsoop/data/report/data_source/report_data_source.dart';
import 'package:dongsoop/data/report/repository/report_repository_impl.dart';
import 'package:dongsoop/domain/auth/repository/auth_repository.dart';
import 'package:dongsoop/domain/auth/use_case/load_user_use_case.dart';
import 'package:dongsoop/domain/report/enum/sanction_type.dart';
import 'package:dongsoop/domain/report/model/report_sanction_status.dart';
import 'package:dongsoop/domain/report/model/report_sanction_response.dart';
import 'package:dongsoop/domain/report/repository/report_repository.dart';
import 'package:dongsoop/domain/report/use_case/get_sanction_status_use_case.dart';
import 'package:dongsoop/presentation/splash/splash_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('제재 상태 저장소', () {
    test('제재가 없으면 로그인 정보를 유지한다', () async {
      final authDataSource = _AuthDataSourceSpy();
      final repository = ReportRepositoryImpl(
        _ReportDataSourceStub(
          const ReportSanctionResponse(isSanctioned: false),
        ),
        authDataSource,
      );

      final result = await repository.getSanctionStatus();

      expect(result, isNull);
      expect(authDataSource.clearLocalDataCalls, 0);
    });

    test('일시정지는 서버 요청 없이 기기 내 로그인 정보만 제거한다', () async {
      final authDataSource = _AuthDataSourceSpy();
      final repository = ReportRepositoryImpl(
        _ReportDataSourceStub(_temporaryBan),
        authDataSource,
      );

      final result = await repository.getSanctionStatus();

      expect(result, same(_temporaryBan));
      expect(authDataSource.clearLocalDataCalls, 1);
      expect(authDataSource.logoutCalls, 0);
      expect(authDataSource.deleteUserCalls, 0);
    });

    test('영구정지는 회원 삭제 없이 기기 내 로그인 정보만 제거한다', () async {
      final authDataSource = _AuthDataSourceSpy();
      final repository = ReportRepositoryImpl(
        _ReportDataSourceStub(_permanentBan),
        authDataSource,
      );

      final result = await repository.getSanctionStatus();

      expect(result, same(_permanentBan));
      expect(authDataSource.clearLocalDataCalls, 1);
      expect(authDataSource.logoutCalls, 0);
      expect(authDataSource.deleteUserCalls, 0);
    });

    test('일시정지 종료일이 없으면 세션을 유지하고 조회 실패로 처리한다', () async {
      final authDataSource = _AuthDataSourceSpy();
      final repository = ReportRepositoryImpl(
        _ReportDataSourceStub(_temporaryBan.copyWith(endDate: null)),
        authDataSource,
      );

      await expectLater(
        repository.getSanctionStatus(),
        throwsA(isA<SanctionStatusException>()),
      );
      expect(authDataSource.clearLocalDataCalls, 0);
    });

    test('사용자 상태 API에 노출되면 안 되는 제재 유형은 진입을 허용하지 않는다', () async {
      final authDataSource = _AuthDataSourceSpy();
      final repository = ReportRepositoryImpl(
        _ReportDataSourceStub(
          _temporaryBan.copyWith(sanctionType: 'WARNING'),
        ),
        authDataSource,
      );

      await expectLater(
        repository.getSanctionStatus(),
        throwsA(isA<SanctionStatusException>()),
      );
      expect(authDataSource.clearLocalDataCalls, 0);
    });
  });

  group('제재 상태 화면 모델', () {
    test('일시정지 종료 시각을 표시용 문자열로 변환한다', () async {
      final useCase = GetSanctionStatusUseCase(
        _ReportRepositoryStub(_temporaryBan),
      );

      final status = await useCase.execute();

      expect(status?.sanctionType, SanctionType.TEMPORARY_BAN);
      expect(status?.startDate, '2026. 10. 15 9:30');
      expect(status?.endDate, '2026. 10. 18 23:59');
      expect(status?.periodLabel, '2026. 10. 15 9:30 ~ 2026. 10. 18 23:59');
    });

    test('영구정지의 종료 시각을 영구로 표시한다', () async {
      final useCase = GetSanctionStatusUseCase(
        _ReportRepositoryStub(_permanentBan),
      );

      final status = await useCase.execute();

      expect(status?.sanctionType, SanctionType.PERMANENT_BAN);
      expect(status?.endDate, isNull);
      expect(status?.endDateLabel, '영구');
      expect(status?.periodLabel, '2026. 10. 15 9:30 ~ 영구');
    });

    test('제재 안내는 유형, 사유, 내용, 기간을 구분해 표시한다', () async {
      final useCase = GetSanctionStatusUseCase(
        _ReportRepositoryStub(_temporaryBan),
      );

      final status = await useCase.execute();

      expect(
        status?.noticeMessage,
        '제재 유형: 일시정지\n'
        '제재 사유: 채팅 욕설\n'
        '제재 내용: 운영정책 위반\n'
        '제재 기간: 2026. 10. 15 9:30 ~ 2026. 10. 18 23:59',
      );
    });

    test('제재 사유와 내용이 같으면 같은 문구를 두 번 표시하지 않는다', () {
      const status = ReportSanctionStatus(
        sanctionType: SanctionType.PERMANENT_BAN,
        reason: '반복 욕설',
        description: '반복 욕설',
        startDate: '2026. 10. 15 9:30',
        endDate: null,
      );

      expect(
        status.noticeMessage,
        '제재 유형: 영구정지\n'
        '제재 사유: 반복 욕설\n'
        '제재 기간: 2026. 10. 15 9:30 ~ 영구',
      );
    });

    test('불완전한 일시정지는 앱 진입 가능한 상태로 변환하지 않는다', () {
      final useCase = GetSanctionStatusUseCase(
        _ReportRepositoryStub(_temporaryBan.copyWith(endDate: null)),
      );

      expect(
        useCase.execute(),
        throwsA(isA<SanctionStatusException>()),
      );
    });
  });

  test('제재 상태 조회 실패는 제재 없음으로 바꾸지 않고 호출자에게 전달한다', () async {
    final viewModel = SplashViewModel(
      LoadUserUseCase(_AuthRepositoryStub()),
      GetSanctionStatusUseCase(_ThrowingReportRepositoryStub()),
      _RefStub(),
    );

    await expectLater(
      viewModel.checkSanction(),
      throwsA(isA<SanctionStatusException>()),
    );
    expect(viewModel.state.isLoading, isFalse);
    expect(viewModel.state.isSuccessed, isFalse);
    expect(viewModel.state.errorMessage, isNull);

    viewModel.dispose();
  });
}

final _temporaryBan = ReportSanctionResponse(
  isSanctioned: true,
  sanctionType: 'TEMPORARY_BAN',
  reason: '채팅 욕설',
  startDate: DateTime(2026, 10, 15, 9, 30),
  endDate: DateTime(2026, 10, 18, 23, 59),
  description: '운영정책 위반',
);

final _permanentBan = ReportSanctionResponse(
  isSanctioned: true,
  sanctionType: 'PERMANENT_BAN',
  reason: '반복 위반',
  startDate: DateTime(2026, 10, 15, 9, 30),
  endDate: null,
  description: '영구 이용 제한',
);

class _ReportDataSourceStub implements ReportDataSource {
  final ReportSanctionResponse response;

  _ReportDataSourceStub(this.response);

  @override
  Future<ReportSanctionResponse> getSanctionStatus() async => response;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _AuthDataSourceSpy implements AuthDataSource {
  int clearLocalDataCalls = 0;
  int logoutCalls = 0;
  int deleteUserCalls = 0;

  @override
  Future<void> clearLocalData() async {
    clearLocalDataCalls++;
  }

  @override
  Future<void> logout() async {
    logoutCalls++;
  }

  @override
  Future<void> deleteUser() async {
    deleteUserCalls++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ReportRepositoryStub implements ReportRepository {
  final ReportSanctionResponse? response;

  _ReportRepositoryStub(this.response);

  @override
  Future<ReportSanctionResponse?> getSanctionStatus() async => response;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ThrowingReportRepositoryStub implements ReportRepository {
  @override
  Future<ReportSanctionResponse?> getSanctionStatus() {
    throw const SanctionStatusException('조회 실패');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _AuthRepositoryStub implements AuthRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _RefStub implements Ref {
  @override
  void onDispose(void Function() cb) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
