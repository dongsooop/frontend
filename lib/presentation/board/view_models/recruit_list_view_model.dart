import 'package:dongsoop/domain/auth/model/department_type_ext.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_list_entity.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_list_use_case.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';
import 'package:dongsoop/presentation/board/providers/recruit/recruit_list_use_case_provider.dart';
import 'package:dongsoop/providers/auth_providers.dart';
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
  late String _departmentCode;

  @override
  RecruitListState build(RecruitType type) {
    _useCase = ref.watch(recruitListUseCaseProvider);
    _type = type;

    _initialize();
    return RecruitListState();
  }

  Future<void> _initialize() async {
    final user = ref.read(userSessionProvider.notifier).state;

    if (user == null) {
      state = state.copyWith(error: '유저 정보가 없습니다.');
      return;
    }

    // displayName 기준으로 enum 매핑 후 code 추출
    final enumType =
        DepartmentTypeExtension.fromDisplayName(user.departmentType);
    _departmentCode = enumType.code;

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

  void refresh() {
    state = RecruitListState();
    loadNextPage();
  }
}
