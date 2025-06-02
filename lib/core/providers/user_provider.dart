import 'package:dio/dio.dart';
import 'package:dongsoop/domain/auth/entities/user_entity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AuthRepository {
  Future<UserEntity?> loadUser();
  Future<void> logout();
}

// 테스트용 구현 (.env에서 유저 정보 로드)
class DummyAuthRepository implements AuthRepository {
  @override
  Future<UserEntity?> loadUser() async {
    final mode = dotenv.env['MODE'];

    // 강제 비로그인 모드
    if (mode != 'login') return null;

    final id = dotenv.env['LOGIN_EMAIL'] ?? '';
    final pw = dotenv.env['LOGIN_PWD'] ?? '';
    final departmentType = dotenv.env['USER_DEPARTMENT'] ?? '';

    final token = await _loginAndGetToken(id, pw);
    if (token == null || token.isEmpty) return null;

    return UserEntity(
      nickname: '테스트유저',
      departmentType: departmentType,
      accessToken: token,
    );
  }

  Future<String?> _loginAndGetToken(String id, String pw) async {
    try {
      final response = await Dio().post(
        '${dotenv.env['BASE_URL']}${dotenv.env['LOGIN_ENDPOINT']}',
        data: {
          'email': id,
          'password': pw,
        },
      );

      if (response.statusCode == 200) {
        return response.data['accessToken'];
      } else {
        return null;
      }
    } catch (e) {
      print('로그인 실패: $e');
      return null;
    }
  }

  @override
  Future<void> logout() async {
    // 테스트에서 별도 처리 x
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return DummyAuthRepository();
});

class UserNotifier extends StateNotifier<UserEntity?> {
  final AuthRepository authRepository;

  UserNotifier(this.authRepository) : super(null);

  Future<void> loadUser() async {
    final user = await authRepository.loadUser();
    state = user;
  }

  Future<void> logout() async {
    await authRepository.logout();
    state = null;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserEntity?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return UserNotifier(authRepository);
});
