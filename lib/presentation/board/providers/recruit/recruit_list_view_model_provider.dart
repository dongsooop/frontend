import 'package:dongsoop/core/providers/user_provider.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';
import 'package:dongsoop/presentation/board/providers/recruit/recruit_list_use_case_provider.dart';
import 'package:dongsoop/presentation/board/view_models/recruit_list_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recruitListViewModelProvider = StateNotifierProvider.family<
    RecruitListViewModel, RecruitListState, RecruitType>((ref, type) {
  final useCase = ref.watch(recruitListUseCaseProvider);
  final user = ref.watch(userProvider);

  final accessToken = user?.accessToken;
  final departmentType = user?.departmentType;

  if (accessToken == null || departmentType == null) {
    throw Exception('유저 인증 정보가 존재하지 않습니다.');
  }

  return RecruitListViewModel(
    useCase: useCase,
    type: type,
    accessToken: accessToken,
    departmentType: departmentType,
  );
});
