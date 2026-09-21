import 'package:dongsoop/domain/eclass/entity/eclass_assignment_list_entity.dart';

const _notProvided = Object();

class EclassAssignmentListState {
  final bool isInitialLoading;
  final bool isRefreshing;
  final EclassAssignmentListEntity? result;
  final String? loadError;
  final String? actionError;

  const EclassAssignmentListState({
    required this.isInitialLoading,
    required this.isRefreshing,
    required this.result,
    required this.loadError,
    required this.actionError,
  });

  factory EclassAssignmentListState.initial() {
    return const EclassAssignmentListState(
      isInitialLoading: true,
      isRefreshing: false,
      result: null,
      loadError: null,
      actionError: null,
    );
  }

  EclassAssignmentListState copyWith({
    bool? isInitialLoading,
    bool? isRefreshing,
    Object? result = _notProvided,
    Object? loadError = _notProvided,
    Object? actionError = _notProvided,
  }) {
    return EclassAssignmentListState(
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      result: identical(result, _notProvided)
          ? this.result
          : result as EclassAssignmentListEntity?,
      loadError: identical(loadError, _notProvided)
          ? this.loadError
          : loadError as String?,
      actionError: identical(actionError, _notProvided)
          ? this.actionError
          : actionError as String?,
    );
  }
}
