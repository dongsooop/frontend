import 'package:flutter_riverpod/flutter_riverpod.dart';

class BoardTabState {
  final int categoryIndex; // 모집(0) / 장터(1)
  final int recruitTabIndex; // 튜터링, 스터디, 프로젝트 (0~2)
  final int marketTabIndex; // 판매, 구매 (0~1)

  const BoardTabState({
    this.categoryIndex = 0,
    this.recruitTabIndex = 0,
    this.marketTabIndex = 0,
  });

  BoardTabState copyWith({
    int? categoryIndex,
    int? recruitTabIndex,
    int? marketTabIndex,
  }) {
    return BoardTabState(
      categoryIndex: categoryIndex ?? this.categoryIndex,
      recruitTabIndex: recruitTabIndex ?? this.recruitTabIndex,
      marketTabIndex: marketTabIndex ?? this.marketTabIndex,
    );
  }
}

class BoardTabNotifier extends StateNotifier<BoardTabState> {
  BoardTabNotifier() : super(const BoardTabState());

  void setCategoryIndex(int index) {
    state = state.copyWith(categoryIndex: index);
  }

  void setRecruitTabIndex(int index) {
    state = state.copyWith(recruitTabIndex: index);
  }

  void setMarketTabIndex(int index) {
    state = state.copyWith(marketTabIndex: index);
  }
}

final boardTabProvider = StateNotifierProvider<BoardTabNotifier, BoardTabState>(
  (ref) => BoardTabNotifier(),
);
