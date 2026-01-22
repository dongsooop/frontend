import 'dart:async';
import 'package:dongsoop/presentation/search/providers/auto_complete_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'popular_search_view_model.g.dart';

@riverpod
class PopularSearchViewModel extends _$PopularSearchViewModel {
  @override
  FutureOr<List<String>> build() async {
    final useCase = ref.read(popularSearchUseCaseProvider);
    final list = await useCase.execute();
    return list;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final useCase = ref.read(popularSearchUseCaseProvider);
      final items = await useCase.execute();
      state = AsyncData(items);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void clear() {
    state = const AsyncData(<String>[]);
  }
}