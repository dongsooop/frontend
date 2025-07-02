import 'package:flutter/widgets.dart';

typedef StateGetter<T> = T Function();
typedef StateChecker<T> = bool Function(T state);

VoidCallback setupScrollListener<T>({
  required ScrollController scrollController,
  required StateGetter<T> getState,
  required StateChecker<T> canFetchMore,
  required VoidCallback fetchMore,
}) {
  void listener() {
    final isBottom = scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 100;
    final state = getState();

    if (isBottom && canFetchMore(state)) {
      fetchMore();
    }
  }

  scrollController.addListener(listener);
  return () => scrollController.removeListener(listener);
}
