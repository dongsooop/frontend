import 'package:dongsoop/data/board/recruit/apply/repositories/recruit_apply_repository_impl.dart';
import 'package:dongsoop/domain/board/recruit/apply/use_case/recruit_decision_use_case.dart';
import 'package:dongsoop/presentation/board/providers/recruit/apply/recruit_apply_data_source_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recruitDecisionUseCaseProvider = Provider<RecruitDecisionUseCase>((ref) {
  final dataSource = ref.watch(recruitApplyDataSourceProvider);
  final repository = RecruitApplyRepositoryImpl(dataSource);

  return RecruitDecisionUseCase(repository);
});
