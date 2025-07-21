import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_list_use_case.dart';
import 'package:dongsoop/presentation/board/providers/recruit/recruit_list_use_case_provider.dart';
import 'package:dongsoop/presentation/board/recruit/list/state/recruit_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recruit_list_view_model.g.dart';

@riverpod
class RecruitListViewModel extends _$RecruitListViewModel {
  late RecruitListUseCase _useCase;
  late RecruitType _type;
  late String _departmentCode;

  static const int _pageSize = 10;
  bool _initialized = false;

  @override
  RecruitListState build({
    required RecruitType type,
    required String departmentCode,
  }) {
    _useCase = ref.watch(recruitListUseCaseProvider);
    _type = type;
    _departmentCode = departmentCode;

    state = RecruitListState();

    Future.microtask(() => _initialize());

    return state;
  }

  Future<void> _initialize() async {
    if (_initialized) return;
    _initialized = true;
    await loadNextPage();
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final newPosts = await _useCase.execute(
        type: _type,
        page: state.page,
        departmentType: _departmentCode,
      );

      final filtered = newPosts.where((e) => e.state).toList();

      final uniquePosts = filtered
          .where(
            (newPost) =>
                !state.posts.any((existing) => existing.id == newPost.id),
          )
          .toList();

      state = state.copyWith(
        posts: [...state.posts, ...uniquePosts],
        page: state.page + 1,
        isLoading: false,
        hasMore: filtered.length == _pageSize,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    _initialized = false;
    state = RecruitListState();
    await _initialize();
  }
}
