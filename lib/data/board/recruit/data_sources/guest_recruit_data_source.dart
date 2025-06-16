import 'package:dongsoop/data/board/recruit/models/recruit_detail_model.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_list_model.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_types.dart';

abstract class GuestRecruitDataSource {
  Future<List<RecruitListModel>> fetchGuestList({
    required RecruitType type,
    required int page,
  });

  Future<RecruitDetailModel> fetchGuestDetail({
    required int id,
    required RecruitType type,
  });
}
