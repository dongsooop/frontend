import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/auth/use_case/login_use_case.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/providers/auth_providers.dart';

class SignInViewModel extends StateNotifier<AsyncValue<void>> {
  final LoginUseCase _loginUseCase;
  final Ref _ref;

  SignInViewModel(
    this._loginUseCase,
    this._ref,
  ) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    try {
      await _loginUseCase.execute(email, password);
      // 로그인한 유저 정보 로딩
      final user = await _ref.read(authRepositoryProvider).getUser();
      _ref.read(userSessionProvider.notifier).state = user;
      state = AsyncValue.data(null);
    } on LoginException catch (e, st) {
      state = AsyncValue.error(e.message, st);
    } catch (e, st) {
      logger.e("Login Error: ${e.runtimeType}", error: e, stackTrace: st);
      state = AsyncValue.error("로그인 중 오류가 발생했습니다.", st);
    }
  }
}
