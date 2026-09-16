import 'package:dongsoop/domain/eclass/repository/eclass_credentials_repository.dart';

class DeleteEclassCredentialsUseCase {
  final EclassCredentialsRepository _repository;

  DeleteEclassCredentialsUseCase(this._repository);

  Future<void> execute() => _repository.delete();
}
