import 'dart:async';

import 'package:dongsoop/domain/search/enum/board_type.dart';
import 'package:dongsoop/presentation/search/providers/auto_complete_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auto_complete_view_model.g.dart';

@riverpod
class AutocompleteViewModel extends _$AutocompleteViewModel {
  Timer? _debounce;
  int _seq = 0;

  @override
  FutureOr<List<String>> build() {
    ref.onDispose(() {
      _debounce?.cancel();
      _debounce = null;
    });

    return const <String>[];
  }

  void onQueryChanged(
      String query, {
        required SearchBoardType boardType,
      }) {
    final q = query.trim();

    if (q.isEmpty) {
      _invalidateAndClear();
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final mySeq = ++_seq;

      state = const AsyncLoading();

      try {
        final useCase = ref.read(autoCompleteUseCaseProvider);
        final result = await useCase.execute(
          keyword: q,
          boardType: boardType,
        );

        if (mySeq != _seq) return;

        state = AsyncData(result);
      } catch (e, st) {
        if (mySeq != _seq) return;
        state = AsyncError(e, st);
      }
    });
  }

  void clear() => _invalidateAndClear();

  void _invalidateAndClear() {
    _debounce?.cancel();
    _debounce = null;
    _seq++;
    state = const AsyncData(<String>[]);
  }
}