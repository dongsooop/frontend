import 'package:dongsoop/domain/auth/use_case/load_user_use_case.dart';
import 'package:dongsoop/domain/auth/use_case/token_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/domain/auth/model/user.dart';
import 'package:dongsoop/domain/auth/use_case/logout_use_case.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/providers/auth_providers.dart';


class MyPageViewModel extends StateNotifier<AsyncValue<User?>> {
  final LoadUserUseCase _loadUserUseCase;
  final LogoutUseCase _logoutUseCase;
  final TokenTestUseCase _tokenTestUseCase;
  final Ref _ref;

  MyPageViewModel(
    this._loadUserUseCase,
    this._logoutUseCase,
    this._tokenTestUseCase,
    this._ref,
  ) : super(const AsyncValue.data(null));

  Future<User?> loadUserInfo() async {
    state = const AsyncValue.loading();

    try {
      final user = await _loadUserUseCase.execute();
      logger.i("user: ${user.toString()}");
      state = AsyncValue.data(user);

      _ref.read(userSessionProvider.notifier).state = user;
    } catch (e, st) {
      logger.e("Login Error: ${e.runtimeType}", error: e, stackTrace: st);
      state = AsyncValue.error("사용자 정보를 불러오는 중 오류가 발생했습니다.", st);
    }
    return null;
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();

    try {
      await _logoutUseCase.execute();
      _ref.read(userSessionProvider.notifier).state = null;
      state = const AsyncValue.data(null);
    } catch (e, st) {
      logger.e("Login Error: ${e.runtimeType}", error: e, stackTrace: st);
      state = AsyncValue.error("로그아웃 중 오류가 발생했습니다.", st);
    }
  }

  Future<void> tokenTest() async {
    try {
      await _tokenTestUseCase.execute();
    } catch (e, st) {
      logger.e("Token Error: ${e.runtimeType}", error: e, stackTrace: st);
      state = AsyncValue.error("토큰 테스트 중 오류가 발생했습니다.", st);
    }
    return null;
  }
}

