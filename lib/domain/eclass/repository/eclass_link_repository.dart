import 'package:dongsoop/domain/eclass/entity/eclass_credentials.dart';
import 'package:dongsoop/domain/eclass/entity/eclass_link_entity.dart';

abstract class EclassLinkRepository {
  Future<EclassLinkEntity> link({
    required EclassCredentials credentials,
    String? fid,
    String? deviceToken,
  });

  Future<EclassLinkEntity> getLink({
    String? fid,
    String? deviceToken,
  });

  Future<void> unlink({
    String? fid,
    String? deviceToken,
  });
}
