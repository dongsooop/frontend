import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/board/recruit/data_sources/recruit_write_data_source.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/repositories/recruit_write_repository.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';

class RecruitWriteRepositoryImpl implements RecruitWriteRepository {
  final RecruitWriteDataSource dataSource;

  RecruitWriteRepositoryImpl(this.dataSource);

  @override
  Future<void> submitRecruitPost({
    required RecruitType type,
    required RecruitWriteEntity entity,
  }) async {
    try {
      await dataSource.submitRecruitPost(
        type: type,
        entity: entity,
      );
    } catch (e) {
      throw RecruitWriteException();
    }
  }
}
