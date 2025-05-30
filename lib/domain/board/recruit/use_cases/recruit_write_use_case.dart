import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/repositories/recruit_write_repository.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';

class RecruitWriteUseCase {
  final RecruitWriteRepository repository;

  RecruitWriteUseCase(this.repository);

  Future<void> call({
    required RecruitType type,
    required String accessToken,
    required RecruitWriteEntity entity,
  }) {
    print('[USECASE] 호출됨');
    return repository.submitRecruitPost(
      type: type,
      accessToken: accessToken,
      entity: entity,
    );
  }
}
