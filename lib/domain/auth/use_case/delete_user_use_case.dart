import 'package:dongsoop/domain/auth/repository/auth_repository.dart';
import 'package:dongsoop/domain/chat/repository/chat_repository.dart';

class DeleteUserUseCase {
  final AuthRepository _authRepository;
  final ChatRepository _chatRepository;

  DeleteUserUseCase(
    this._authRepository,
    this._chatRepository,
  );

  Future<void> execute() async {
    // 탈퇴 + 로그인 후 로컬 저장 정보 삭제
    await _authRepository.deleteUser();
    await _chatRepository.deleteChatBox();
    await _authRepository.logout();
  }
}