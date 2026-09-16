import 'package:dongsoop/presentation/eclass/assignment/view_model/eclass_assignment_list_state.dart';
import 'package:dongsoop/presentation/eclass/assignment/view_model/eclass_assignment_list_view_model.dart';
import 'package:dongsoop/providers/device_providers.dart';
import 'package:dongsoop/providers/eclass_assignment_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eclassAssignmentListViewModelProvider = StateNotifierProvider.autoDispose<
    EclassAssignmentListViewModel, EclassAssignmentListState>((ref) {
  return EclassAssignmentListViewModel(
    ref.watch(getEclassAssignmentsUseCaseProvider),
    ref.watch(syncEclassAssignmentsUseCaseProvider),
    ref.watch(getFidUseCaseProvider),
    ref.watch(getFcmTokenUseCaseProvider),
  );
});
