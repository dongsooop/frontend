import 'package:dongsoop/data/eclass/data_source/eclass_credentials_local_data_source.dart';
import 'package:dongsoop/data/eclass/model/eclass_credentials_local_model.dart';
import 'package:dongsoop/domain/eclass/entity/eclass_credentials.dart';
import 'package:dongsoop/domain/eclass/repository/eclass_credentials_repository.dart';

class EclassCredentialsRepositoryImpl implements EclassCredentialsRepository {
  final EclassCredentialsLocalDataSource _localDataSource;

  EclassCredentialsRepositoryImpl(this._localDataSource);

  @override
  Future<void> save(EclassCredentials credentials) {
    return _localDataSource.save(
      EclassCredentialsLocalModel(
        eclassId: credentials.eclassId,
        password: credentials.password,
      ),
    );
  }

  @override
  Future<EclassCredentials?> read() async {
    final credentials = await _localDataSource.read();
    if (credentials == null) return null;

    return EclassCredentials(
      eclassId: credentials.eclassId,
      password: credentials.password,
    );
  }

  @override
  Future<void> delete() => _localDataSource.delete();
}
