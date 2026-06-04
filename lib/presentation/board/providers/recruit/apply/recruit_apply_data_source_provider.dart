import 'package:dongsoop/data/board/recruit/apply/data_sources/recruit_apply_data_source_impl.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recruitApplyDataSourceProvider = Provider<RecruitApplyDataSourceImpl>((ref) {
  final dio = ref.watch(authDioProvider);

  return RecruitApplyDataSourceImpl(dio);
});
