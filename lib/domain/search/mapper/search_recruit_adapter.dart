import 'package:dongsoop/domain/board/recruit/entities/recruit_list_entity.dart';
import 'package:dongsoop/domain/search/entity/search_recruit_entity.dart';

extension SearchRecruitAdapter on SearchRecruitEntity {
  RecruitListEntity toRecruitListEntity({DateTime? now}) {
    final nowTime = now ?? DateTime.now();

    return RecruitListEntity(
        id: id,
        volunteer: volunteer,          // 검색 응답의 contactCount → volunteer 로 매핑
        startAt: startAt,              // recruitmentStartAt
        endAt: endAt,                  // recruitmentEndAt
        title: title,
        content: content,
        tags: tags,                    // 이미 모델에서 정제했다면 그대로 전달
        state: nowTime.isBefore(endAt) // 모집 중 여부 계산
    );
  }
}
