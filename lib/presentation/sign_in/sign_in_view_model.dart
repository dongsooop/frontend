import 'package:dongsoop/presentation/sign_in/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/auth/model/login_response.dart';
import 'package:dongsoop/domain/auth/use_case/login_use_case.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/providers/secure_storage_provider.dart';
import 'package:dongsoop/providers/shared_preferences_provider.dart';

final loginViewModelProvider =
StateNotifierProvider<LoginViewModel, AsyncValue<LoginResponse?>>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final sharedPrefs = ref.watch(sharedPreferencesProvider);

  return LoginViewModel(loginUseCase, secureStorage, sharedPrefs);
});

class LoginViewModel extends StateNotifier<AsyncValue<LoginResponse?>> {
  final LoginUseCase _loginUseCase;
  final SecureStorageService _secureStorage;
  final SharedPreferencesService _sharedPrefs;

  LoginViewModel(
      this._loginUseCase,
      this._secureStorage,
      this._sharedPrefs,
      ) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    try {
      final response = await _loginUseCase.execute(email, password);
      // storage에 access token 저장, refreshToken은 쿠키로 오니 별도 처리 X
      await _secureStorage.write("accessToken", response.accessToken);
      // shared preferences에 사용자 정보(닉네임, 학과, 이메일) 저장
      await _sharedPrefs.setString('nickname', response.nickname);
      await _sharedPrefs.setString('email', response.email);
      await _sharedPrefs.setString('departmentType', response.departmentType);

      state = AsyncValue.data(response);
    } on LoginException catch (e, st) {
      state = AsyncValue.error(e.message, st);
    } catch (e, st) {
      logger.e("Login Error: ${e.runtimeType}", error: e, stackTrace: st);
      state = AsyncValue.error("로그인 중 오류가 발생했습니다.", st);
    }
  }
}
