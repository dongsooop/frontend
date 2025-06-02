import 'package:dongsoop/domain/auth/model/user.dart';
import 'package:dongsoop/domain/auth/repository/auth_repository.dart';

class LoadUserUseCase {
  final AuthRepository _authRepository;

  LoadUserUseCase(
    this._authRepository,
  );

  Future<User?> execute() async {
    final user = await _authRepository.getUser();
    return user;
  }
}