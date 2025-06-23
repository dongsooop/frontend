import 'package:dongsoop/data/board/recruit/data_sources/guest_recruit_data_source_impl.dart';
import 'package:dongsoop/data/board/recruit/data_sources/recruit_data_source_impl.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:dongsoop/providers/plain_dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final guestRecruitDataSourceProvider = Provider(
  (ref) => GuestRecruitDataSourceImpl(ref.watch(plainDioProvider)),
);

final recruitDataSourceProvider = Provider(
  (ref) => RecruitDataSourceImpl(ref.watch(authDioProvider)),
);
