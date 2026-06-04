import 'package:dongsoop/domain/auth/repository/auth_repository.dart';

class UserBlockUseCase {
  final AuthRepository _authRepository;

  UserBlockUseCase(
    this._authRepository,
  );

  Future<void> execute(int blockerId, int blockedMemberId) async {
    await _authRepository.userBlock(blockerId, blockedMemberId);
  }
}
