import 'package:dongsoop/core/exception/eclass_exception.dart';
import 'package:dongsoop/domain/eclass/entity/eclass_credentials.dart';
import 'package:dongsoop/domain/eclass/entity/eclass_link_entity.dart';
import 'package:dongsoop/domain/eclass/repository/eclass_link_repository.dart';

class LinkEclassUseCase {
  final EclassLinkRepository _repository;

  LinkEclassUseCase(this._repository);

  Future<EclassLinkEntity> execute({
    required String eclassId,
    required String password,
    String? fid,
    String? deviceToken,
  }) {
    final normalizedId = eclassId.trim();
    if (normalizedId.isEmpty || password.isEmpty) {
      throw const EclassInvalidCredentialsException(
        'Eclass 아이디와 비밀번호를 입력해 주세요.',
      );
    }

    return _repository.link(
      credentials: EclassCredentials(
        eclassId: normalizedId,
        password: password,
      ),
      fid: fid,
      deviceToken: deviceToken,
    );
  }
}
