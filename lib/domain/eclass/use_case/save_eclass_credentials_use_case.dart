import 'package:dongsoop/core/exception/eclass_exception.dart';
import 'package:dongsoop/domain/eclass/entity/eclass_credentials.dart';
import 'package:dongsoop/domain/eclass/repository/eclass_credentials_repository.dart';

class SaveEclassCredentialsUseCase {
  final EclassCredentialsRepository _repository;

  SaveEclassCredentialsUseCase(this._repository);

  Future<void> execute({
    required String eclassId,
    required String password,
  }) {
    final normalizedId = eclassId.trim();
    if (normalizedId.isEmpty || password.isEmpty) {
      throw const EclassInvalidCredentialsException(
        'Eclass 아이디와 비밀번호를 입력해 주세요.',
      );
    }

    return _repository.save(
      EclassCredentials(
        eclassId: normalizedId,
        password: password,
      ),
    );
  }
}
