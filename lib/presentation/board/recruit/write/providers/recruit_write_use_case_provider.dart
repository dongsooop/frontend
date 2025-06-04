import 'package:dongsoop/data/board/recruit/data_sources/recruit_write_data_source.dart';
import 'package:dongsoop/data/board/recruit/repositories/recruit_write_repository_impl.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_write_use_case.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recruitWriteUseCaseProvider = Provider<RecruitWriteUseCase>((ref) {
  final dio = ref.watch(authDioProvider);
  final dataSource = RecruitWriteDataSource(dio);
  final repository = RecruitWriteRepositoryImpl(dataSource);
  return RecruitWriteUseCase(repository);
});
