import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/auth/enum/login_platform.dart';
import 'package:dongsoop/domain/auth/model/user.dart';
import 'package:dongsoop/domain/auth/use_case/load_user_use_case.dart';
import 'package:dongsoop/domain/auth/use_case/sign_in_use_case.dart';
import 'package:dongsoop/domain/auth/use_case/social_login_use_case.dart';
import 'package:dongsoop/domain/report/enum/sanction_type.dart';
import 'package:dongsoop/domain/report/model/report_sanction_status.dart';
import 'package:dongsoop/presentation/sign_in/sign_in_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('로그인 제재 안내', () {
    test('일반 로그인 제재를 입력창 오류 대신 이용 제한 다이얼로그로 전달한다', () async {
      final viewModel = SignInViewModel(
        _SanctionedSignInUseCase('일시정지 상세 안내', _temporaryBan),
        _UnusedSocialLoginUseCase(),
        _UnusedLoadUserUseCase(),
        _RefStub(),
      );

      await viewModel.login('user', 'password');

      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.errorMessage, isNull);
      expect(viewModel.state.dialogTitle, '동숲 이용 제재');
      expect(viewModel.state.dialogMessage, '일시정지 상세 안내');
      expect(viewModel.state.sanction, same(_temporaryBan));
      expect(
        viewModel.state.sanction?.noticeMessage,
        '제재 유형: 일시정지\n'
        '제재 사유: 반복 욕설\n'
        '제재 내용: 경고 3회 누적\n'
        '제재 기간: 2026. 10. 16 21:20 ~ 2026. 10. 19 21:20',
      );
      viewModel.dispose();
    });

    test('소셜 로그인 제재도 같은 이용 제한 다이얼로그로 전달한다', () async {
      final viewModel = SignInViewModel(
        _UnusedSignInUseCase(),
        _SanctionedSocialLoginUseCase('영구정지 상세 안내', _permanentBan),
        _UnusedLoadUserUseCase(),
        _RefStub(),
      );

      await viewModel.socialLogin(LoginPlatform.google);

      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.dialogTitle, '동숲 이용 제재');
      expect(viewModel.state.dialogMessage, '영구정지 상세 안내');
      expect(viewModel.state.sanction, same(_permanentBan));
      viewModel.dispose();
    });

    test('안내를 확인하면 다이얼로그 상태를 제거한다', () async {
      final viewModel = SignInViewModel(
        _SanctionedSignInUseCase('제재 안내'),
        _UnusedSocialLoginUseCase(),
        _UnusedLoadUserUseCase(),
        _RefStub(),
      );
      await viewModel.login('user', 'password');

      viewModel.clearErrorMessage();

      expect(viewModel.state.dialogTitle, isNull);
      expect(viewModel.state.dialogMessage, isNull);
      expect(viewModel.state.sanction, isNull);
      viewModel.dispose();
    });
  });
}

class _SanctionedSignInUseCase implements SignInUseCase {
  _SanctionedSignInUseCase(this.message, [this.sanction]);

  final String message;
  final ReportSanctionStatus? sanction;

  @override
  Future<void> execute(String email, String password) {
    throw UserSanctionedException(message, sanction);
  }
}

class _UnusedSignInUseCase implements SignInUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SanctionedSocialLoginUseCase implements SocialLoginUseCase {
  _SanctionedSocialLoginUseCase(this.message, [this.sanction]);

  final String message;
  final ReportSanctionStatus? sanction;

  @override
  Future<void> execute(LoginPlatform platform) {
    throw UserSanctionedException(message, sanction);
  }
}

class _UnusedSocialLoginUseCase implements SocialLoginUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedLoadUserUseCase implements LoadUserUseCase {
  @override
  Future<User?> execute() async => null;
}

class _RefStub implements Ref {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _temporaryBan = ReportSanctionStatus(
  sanctionType: SanctionType.TEMPORARY_BAN,
  reason: '반복 욕설',
  description: '경고 3회 누적',
  startDate: '2026. 10. 16 21:20',
  endDate: '2026. 10. 19 21:20',
);

const _permanentBan = ReportSanctionStatus(
  sanctionType: SanctionType.PERMANENT_BAN,
  reason: '반복 신고',
  description: '영구 이용 제한',
  startDate: '2026. 10. 16 21:20',
  endDate: null,
);
