import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/board/recruit/apply/enum/recruit_applicant_viewer.dart';

final activeRecruitListContextProvider =
StateProvider.autoDispose<({RecruitType type, int boardId})?>((ref) => null);

final activeRecruitDetailContextProvider =
    StateProvider.autoDispose<({
    RecruitApplicantViewer viewer,
    RecruitType type,
    int boardId,
    int? memberId,
})?>((ref) => null);

final activeChatListContextProvider = StateProvider<bool>((ref) => false);