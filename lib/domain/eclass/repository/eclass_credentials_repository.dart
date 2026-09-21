import 'package:dongsoop/domain/eclass/entity/eclass_credentials.dart';

abstract class EclassCredentialsRepository {
  Future<void> save(EclassCredentials credentials);

  Future<EclassCredentials?> read();

  Future<void> delete();
}
