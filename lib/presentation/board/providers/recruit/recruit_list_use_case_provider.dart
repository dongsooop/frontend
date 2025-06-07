import 'package:dongsoop/data/board/recruit/data_sources/recruit_data_source_impl.dart';
import 'package:dongsoop/data/board/recruit/repositories/recruit_repository_impl.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_list_use_case.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recruitListUseCaseProvider = Provider<RecruitListUseCase>((ref) {
  final dio = ref.watch(authDioProvider);

  final dataSource = RecruitDataSourceImpl(dio);
  final repository = RecruitRepositoryImpl(dataSource);

  return RecruitListUseCase(repository);
});
