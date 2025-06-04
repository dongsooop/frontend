import 'package:dongsoop/data/board/recruit/data_sources/recruit_detail_data_source.dart';
import 'package:dongsoop/data/board/recruit/repositories/recruit_detail_repository_impl.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_detail_use_case.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recruitDetailUseCaseProvider = Provider<RecruitDetailUseCase>((ref) {
  final dio = ref.watch(authDioProvider);
  final dataSource = RecruitDetailDataSource(dio);
  final repository = RecruitDetailRepositoryImpl(dataSource);
  return RecruitDetailUseCase(repository);
});
