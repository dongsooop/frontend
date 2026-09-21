import 'package:dongsoop/domain/eclass/entity/eclass_credentials.dart';
import 'package:dongsoop/domain/eclass/repository/eclass_credentials_repository.dart';

class GetEclassCredentialsUseCase {
  final EclassCredentialsRepository _repository;

  GetEclassCredentialsUseCase(this._repository);

  Future<EclassCredentials?> execute() => _repository.read();
}
