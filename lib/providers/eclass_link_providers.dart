import 'package:dio/dio.dart';
import 'package:dongsoop/data/eclass/data_source/eclass_link_data_source.dart';
import 'package:dongsoop/data/eclass/data_source/eclass_link_data_source_impl.dart';
import 'package:dongsoop/data/eclass/data_source/eclass_token_data_source.dart';
import 'package:dongsoop/data/eclass/data_source/eclass_token_data_source_impl.dart';
import 'package:dongsoop/data/eclass/repository/eclass_link_repository_impl.dart';
import 'package:dongsoop/domain/eclass/repository/eclass_link_repository.dart';
import 'package:dongsoop/domain/eclass/use_case/get_eclass_link_use_case.dart';
import 'package:dongsoop/domain/eclass/use_case/link_eclass_use_case.dart';
import 'package:dongsoop/domain/eclass/use_case/unlink_eclass_use_case.dart';
import 'package:dongsoop/providers/plain_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eclassTokenDioProvider = Provider<Dio>((ref) => Dio());

final eclassTokenDataSourceProvider = Provider<EclassTokenDataSource>((ref) {
  return EclassTokenDataSourceImpl(ref.watch(eclassTokenDioProvider));
});

final eclassLinkDataSourceProvider = Provider<EclassLinkDataSource>((ref) {
  return EclassLinkDataSourceImpl(ref.watch(plainDioProvider));
});

final eclassLinkRepositoryProvider = Provider<EclassLinkRepository>((ref) {
  return EclassLinkRepositoryImpl(
    ref.watch(eclassTokenDataSourceProvider),
    ref.watch(eclassLinkDataSourceProvider),
  );
});

final linkEclassUseCaseProvider = Provider<LinkEclassUseCase>((ref) {
  return LinkEclassUseCase(ref.watch(eclassLinkRepositoryProvider));
});

final getEclassLinkUseCaseProvider = Provider<GetEclassLinkUseCase>((ref) {
  return GetEclassLinkUseCase(ref.watch(eclassLinkRepositoryProvider));
});

final unlinkEclassUseCaseProvider = Provider<UnlinkEclassUseCase>((ref) {
  return UnlinkEclassUseCase(ref.watch(eclassLinkRepositoryProvider));
});
