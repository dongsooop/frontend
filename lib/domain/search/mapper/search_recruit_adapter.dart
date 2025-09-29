import 'package:dongsoop/domain/board/recruit/entities/recruit_list_entity.dart';
import 'package:dongsoop/domain/search/entity/search_recruit_entity.dart';

extension SearchRecruitAdapter on SearchRecruitEntity {
  RecruitListEntity toRecruitListEntity({DateTime? now}) {
    final nowTime = now ?? DateTime.now();

    return RecruitListEntity(
        id: id,
        volunteer: volunteer,
        startAt: startAt,
        endAt: endAt,
        title: title,
        content: content,
        tags: tags,
        state: nowTime.isBefore(endAt)
    );
  }
}
