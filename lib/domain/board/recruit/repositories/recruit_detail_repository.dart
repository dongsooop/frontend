import 'package:dongsoop/domain/board/recruit/entities/recruit_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/params/recruit_detail_params.dart';

abstract class RecruitDetailRepository {
  Future<RecruitDetailEntity> fetchRecruitDetail(RecruitDetailParams params);
}
