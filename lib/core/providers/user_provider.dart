import 'package:dongsoop/domain/user/entities/user_entity.dart';
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

    final nickname = dotenv.env['USER_NICKNAME'] ?? '';
    final departmentType = dotenv.env['USER_DEPARTMENT'] ?? '';
    final accessToken = dotenv.env['ACCESS_TOKEN'] ?? '';

    // login 모드인데 토큰이 없으면 비로그인 상태로 처리
    if (accessToken.isEmpty) return null;

    return UserEntity(
      nickname: nickname,
      departmentType: departmentType,
      accessToken: accessToken,
    );
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
