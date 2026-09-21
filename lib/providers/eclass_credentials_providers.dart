import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:dongsoop/data/eclass/data_source/eclass_credentials_local_data_source.dart';
import 'package:dongsoop/data/eclass/data_source/eclass_credentials_local_data_source_impl.dart';
import 'package:dongsoop/data/eclass/repository/eclass_credentials_repository_impl.dart';
import 'package:dongsoop/domain/eclass/repository/eclass_credentials_repository.dart';
import 'package:dongsoop/domain/eclass/use_case/delete_eclass_credentials_use_case.dart';
import 'package:dongsoop/domain/eclass/use_case/get_eclass_credentials_use_case.dart';
import 'package:dongsoop/domain/eclass/use_case/save_eclass_credentials_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eclassCredentialsLocalDataSourceProvider =
    Provider<EclassCredentialsLocalDataSource>((ref) {
  return EclassCredentialsLocalDataSourceImpl(
    ref.watch(secureStorageProvider),
  );
});

final eclassCredentialsRepositoryProvider =
    Provider<EclassCredentialsRepository>((ref) {
  return EclassCredentialsRepositoryImpl(
    ref.watch(eclassCredentialsLocalDataSourceProvider),
  );
});

final saveEclassCredentialsUseCaseProvider =
    Provider<SaveEclassCredentialsUseCase>((ref) {
  return SaveEclassCredentialsUseCase(
    ref.watch(eclassCredentialsRepositoryProvider),
  );
});

final getEclassCredentialsUseCaseProvider =
    Provider<GetEclassCredentialsUseCase>((ref) {
  return GetEclassCredentialsUseCase(
    ref.watch(eclassCredentialsRepositoryProvider),
  );
});

final deleteEclassCredentialsUseCaseProvider =
    Provider<DeleteEclassCredentialsUseCase>((ref) {
  return DeleteEclassCredentialsUseCase(
    ref.watch(eclassCredentialsRepositoryProvider),
  );
});
