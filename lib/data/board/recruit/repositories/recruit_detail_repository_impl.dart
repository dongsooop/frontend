import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/board/recruit/data_sources/recruit_detail_data_source.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_detail_model.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_types.dart';
import 'package:dongsoop/domain/board/recruit/repositories/recruit_detail_repository.dart';

class RecruitDetailRepositoryImpl implements RecruitDetailRepository {
  final RecruitDetailDataSource dataSource;

  RecruitDetailRepositoryImpl(this.dataSource);

  @override
  Future<RecruitDetailEntity> fetchRecruitDetail({
    required int id,
    required RecruitType type,
  }) async {
    try {
      final model = await dataSource.fetchDetailList(
        id: id,
        type: type,
      );
      return model.toEntity();
    } catch (e) {
      throw RecruitDetailException();
    }
  }
}
