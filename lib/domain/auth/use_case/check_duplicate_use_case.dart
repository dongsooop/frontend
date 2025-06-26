import 'package:dongsoop/domain/auth/repository/auth_repository.dart';

class CheckDuplicateUseCase {
  final AuthRepository _authRepository;

  CheckDuplicateUseCase(
    this._authRepository,
  );

  Future<bool> execute(String data, String type) async {
    return await _authRepository.checkValidate(data, type);
  }
}
