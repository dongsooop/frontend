import 'package:dongsoop/domain/board/recruit/entities/recruit_list_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_types.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_list_use_case.dart';
import 'package:dongsoop/presentation/board/providers/recruit/recruit_list_use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recruit_list_view_model.g.dart';

class RecruitListState {
  final List<RecruitListEntity> posts;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final int page;

  RecruitListState({
    this.posts = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.page = 0,
  });

  RecruitListState copyWith({
    List<RecruitListEntity>? posts,
    bool? isLoading,
    bool? hasMore,
    String? error,
    int? page,
  }) {
    return RecruitListState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      page: page ?? this.page,
    );
  }
}

@riverpod
class RecruitListViewModel extends _$RecruitListViewModel {
  late final RecruitListUseCase _useCase;
  late final RecruitType _type;
  late final String _departmentCode;

  @override
  RecruitListState build({
    required RecruitType type,
    required String departmentCode,
  }) {
    _useCase = ref.watch(recruitListUseCaseProvider);
    _type = type;
    _departmentCode = departmentCode;

    Future.microtask(() => _initialize());

    return RecruitListState();
  }

  Future<void> _initialize() async {
    await loadNextPage();
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final newPosts = await _useCase(
        type: _type,
        page: state.page,
        departmentType: _departmentCode,
      );

      final filtered = newPosts.where((e) => e.state).toList();

      state = state.copyWith(
        posts: [...state.posts, ...filtered],
        page: state.page + 1,
        isLoading: false,
        hasMore: filtered.isNotEmpty,
      );
    } catch (e) {
      print('[RecruitListViewModel] 에러 발생: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    state = RecruitListState();
    await loadNextPage();
  }
}
