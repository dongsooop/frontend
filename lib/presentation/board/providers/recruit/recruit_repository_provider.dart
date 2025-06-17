import 'package:dongsoop/data/board/recruit/repositories/guest_recruit_repository_impl.dart';
import 'package:dongsoop/data/board/recruit/repositories/recruit_repository_impl.dart';
import 'package:dongsoop/presentation/board/providers/recruit/recruit_data_source_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final guestRecruitRepositoryProvider = Provider(
  (ref) =>
      GuestRecruitRepositoryImpl(ref.watch(guestRecruitDataSourceProvider)),
);

final recruitRepositoryProvider = Provider(
  (ref) => RecruitRepositoryImpl(ref.watch(recruitDataSourceProvider)),
);
