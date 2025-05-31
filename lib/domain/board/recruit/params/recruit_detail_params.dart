import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';

class RecruitDetailParams {
  final int id;
  final RecruitType type;
  final String accessToken;

  RecruitDetailParams({
    required this.id,
    required this.type,
    required this.accessToken,
  });
}
