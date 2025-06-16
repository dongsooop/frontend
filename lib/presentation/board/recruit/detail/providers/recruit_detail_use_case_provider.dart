import 'package:dongsoop/data/board/recruit/data_sources/guest_recruit_data_source_impl.dart';
import 'package:dongsoop/data/board/recruit/data_sources/recruit_data_source_impl.dart';
import 'package:dongsoop/data/board/recruit/repositories/guest_recruit_repository_impl.dart';
import 'package:dongsoop/data/board/recruit/repositories/recruit_repository_impl.dart';
import 'package:dongsoop/domain/board/recruit/repositories/recruit_repository.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_detail_use_case.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/providers/plain_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recruitDetailUseCaseProvider = Provider<RecruitDetailUseCase>((ref) {
  final user = ref.watch(userSessionProvider); // 로그인 여부 판단

  final RecruitRepository repository;

  if (user != null) {
    final dio = ref.watch(authDioProvider);
    final dataSource = RecruitDataSourceImpl(dio);
    repository = RecruitRepositoryImpl(dataSource);
  } else {
    final dio = ref.watch(plainDioProvider);
    final dataSource = GuestRecruitDataSourceImpl(dio);
    repository = GuestRecruitRepositoryImpl(dataSource);
  }

  return RecruitDetailUseCase(repository);
});
