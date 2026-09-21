import 'package:dongsoop/domain/eclass/entity/eclass_link_entity.dart';
import 'package:dongsoop/domain/eclass/repository/eclass_link_repository.dart';

class GetEclassLinkUseCase {
  final EclassLinkRepository _repository;

  GetEclassLinkUseCase(this._repository);

  Future<EclassLinkEntity> execute({
    String? fid,
    String? deviceToken,
  }) {
    return _repository.getLink(
      fid: fid,
      deviceToken: deviceToken,
    );
  }
}
