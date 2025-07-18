import 'package:dongsoop/data/board/recruit/apply/data_sources/recruit_apply_data_source_impl.dart';
import 'package:dongsoop/data/board/recruit/apply/repositories/recruit_apply_repository_impl.dart';
import 'package:dongsoop/domain/board/recruit/apply/use_case/recruit_decision_use_case.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recruitDecisionUseCaseProvider = Provider<RecruitDecisionUseCase>((ref) {
  final dio = ref.watch(authDioProvider);

  final dataSource = RecruitApplyDataSourceImpl(dio);
  final repository = RecruitApplyRepositoryImpl(dataSource);

  return RecruitDecisionUseCase(repository);
});
