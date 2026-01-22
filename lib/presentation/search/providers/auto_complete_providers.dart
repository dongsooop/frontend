import 'package:dongsoop/domain/search/repository/search_repository.dart';
import 'package:dongsoop/domain/search/use_case/auto_complete_use_case.dart';
import 'package:dongsoop/domain/search/use_case/popular_search_use_case.dart';
import 'package:dongsoop/providers/search_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final autoCompleteUseCaseProvider = Provider<AutocompleteUseCase>((ref) {
  final SearchRepository repository = ref.watch(searchRepositoryProvider);
  return AutocompleteUseCase(repository);
});

final popularSearchUseCaseProvider = Provider<PopularSearchUseCase>((ref) {
  final SearchRepository repository = ref.watch(searchRepositoryProvider);
  return PopularSearchUseCase(repository);
});