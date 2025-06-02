import 'package:dongsoop/data/board/recruit/data_sources/recruit_list_data_source.dart';
import 'package:dongsoop/data/board/recruit/repositories/recruit_list_repository_impl.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_list_use_case.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recruitListUseCaseProvider = Provider<RecruitListUseCase>((ref) {
  final dio = ref.watch(authDioProvider);
  final dataSource = RecruitListDataSource(dio);
  final repository = RecruitListRepositoryImpl(dataSource);
  return RecruitListUseCase(repository);
});
