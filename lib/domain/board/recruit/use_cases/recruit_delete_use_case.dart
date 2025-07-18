import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/board/recruit/repositories/recruit_repository.dart';

class RecruitDeleteUseCase {
  final RecruitRepository _repo;

  RecruitDeleteUseCase(this._repo);

  Future<void> execute({
    required int id,
    required RecruitType type,
  }) async {
    return _repo.deleteRecruitPost(
      id: id,
      type: type,
    );
  }
}
