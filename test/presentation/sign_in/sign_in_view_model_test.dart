import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/auth/enum/login_platform.dart';
import 'package:dongsoop/domain/auth/model/user.dart';
import 'package:dongsoop/domain/auth/use_case/load_user_use_case.dart';
import 'package:dongsoop/domain/auth/use_case/sign_in_use_case.dart';
import 'package:dongsoop/domain/auth/use_case/social_login_use_case.dart';
import 'package:dongsoop/presentation/sign_in/sign_in_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('로그인 제재 안내', () {
    test('일반 로그인 제재를 입력창 오류 대신 이용 제한 다이얼로그로 전달한다', () async {
      final viewModel = SignInViewModel(
        _SanctionedSignInUseCase('일시정지 상세 안내'),
        _UnusedSocialLoginUseCase(),
        _UnusedLoadUserUseCase(),
        _RefStub(),
      );

      await viewModel.login('user', 'password');

      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.errorMessage, isNull);
      expect(viewModel.state.dialogTitle, '동숲 이용 제재');
      expect(viewModel.state.dialogMessage, '일시정지 상세 안내');
      viewModel.dispose();
    });

    test('소셜 로그인 제재도 같은 이용 제한 다이얼로그로 전달한다', () async {
      final viewModel = SignInViewModel(
        _UnusedSignInUseCase(),
        _SanctionedSocialLoginUseCase('영구정지 상세 안내'),
        _UnusedLoadUserUseCase(),
        _RefStub(),
      );

      await viewModel.socialLogin(LoginPlatform.google);

      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.dialogTitle, '동숲 이용 제재');
      expect(viewModel.state.dialogMessage, '영구정지 상세 안내');
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
      viewModel.dispose();
    });
  });
}

class _SanctionedSignInUseCase implements SignInUseCase {
  _SanctionedSignInUseCase(this.message);

  final String message;

  @override
  Future<void> execute(String email, String password) {
    throw UserSanctionedException(message);
  }
}

class _UnusedSignInUseCase implements SignInUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SanctionedSocialLoginUseCase implements SocialLoginUseCase {
  _SanctionedSocialLoginUseCase(this.message);

  final String message;

  @override
  Future<void> execute(LoginPlatform platform) {
    throw UserSanctionedException(message);
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
