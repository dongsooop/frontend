import 'package:dongsoop/domain/eclass/repository/eclass_link_repository.dart';

class UnlinkEclassUseCase {
  final EclassLinkRepository _repository;

  UnlinkEclassUseCase(this._repository);

  Future<void> execute({
    String? fid,
    String? deviceToken,
  }) {
    return _repository.unlink(
      fid: fid,
      deviceToken: deviceToken,
    );
  }
}
