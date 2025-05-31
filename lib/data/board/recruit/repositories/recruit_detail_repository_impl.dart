import 'package:dongsoop/data/board/recruit/data_sources/recruit_detail_data_source.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_detail_model.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/params/recruit_detail_params.dart';
import 'package:dongsoop/domain/board/recruit/repositories/recruit_detail_repository.dart';

class RecruitDetailRepositoryImpl implements RecruitDetailRepository {
  final RecruitDetailDataSource dataSource;
  RecruitDetailRepositoryImpl(this.dataSource);

  @override
  Future<RecruitDetailEntity> fetchRecruitDetail(
      RecruitDetailParams params) async {
    try {
      final model = await dataSource.getRecruitDetailApi(params);
      return model.toEntity();
    } catch (e) {
      throw Exception('모집 상세 가져오기 실패: $e');
    }
  }
}
