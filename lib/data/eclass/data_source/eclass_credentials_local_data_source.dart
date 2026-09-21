import 'package:dongsoop/data/eclass/model/eclass_credentials_local_model.dart';

abstract class EclassCredentialsLocalDataSource {
  Future<void> save(EclassCredentialsLocalModel credentials);

  Future<EclassCredentialsLocalModel?> read();

  Future<void> delete();
}
