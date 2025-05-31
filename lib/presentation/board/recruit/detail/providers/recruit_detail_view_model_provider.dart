import 'package:dongsoop/core/providers/user_provider.dart';
import 'package:dongsoop/domain/board/recruit/params/recruit_detail_params.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';
import 'package:dongsoop/presentation/board/recruit/detail/providers/recruit_detail_use_case_provider.dart';
import 'package:dongsoop/presentation/board/recruit/detail/view_models/recruit_detail_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recruitDetailViewModelProvider = StateNotifierProvider.family<
    RecruitDetailViewModel,
    RecruitDetailState,
    (RecruitType, int)>((ref, tuple) {
  final (type, id) = tuple;
  final useCase = ref.watch(recruitDetailUseCaseProvider);
  final user = ref.watch(userProvider);

  final accessToken = user?.accessToken;

  if (accessToken == null) {
    throw Exception('유저 인증 정보가 존재하지 않습니다.');
  }

  final params = RecruitDetailParams(
    id: id,
    type: type,
    accessToken: accessToken,
  );

  return RecruitDetailViewModel(
    useCase: useCase,
    params: params,
  );
});
