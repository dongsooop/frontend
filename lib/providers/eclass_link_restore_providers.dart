import 'package:dongsoop/domain/eclass/use_case/restore_expired_eclass_link_use_case.dart';
import 'package:dongsoop/presentation/app/eclass_link_restore_controller.dart';
import 'package:dongsoop/presentation/home/view_models/home_view_model.dart';
import 'package:dongsoop/providers/device_providers.dart';
import 'package:dongsoop/providers/eclass_assignment_list_providers.dart';
import 'package:dongsoop/providers/eclass_credentials_providers.dart';
import 'package:dongsoop/providers/eclass_link_management_providers.dart';
import 'package:dongsoop/providers/eclass_link_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restoreExpiredEclassLinkUseCaseProvider =
    Provider<RestoreExpiredEclassLinkUseCase>((ref) {
  return RestoreExpiredEclassLinkUseCase(
    ref.watch(eclassLinkRepositoryProvider),
    ref.watch(eclassCredentialsRepositoryProvider),
  );
});

final eclassLinkRestoreControllerProvider =
    Provider<EclassLinkRestoreController>((ref) {
  return EclassLinkRestoreController(
    ref.watch(restoreExpiredEclassLinkUseCaseProvider),
    ref.watch(getFidUseCaseProvider),
    ref.watch(getFcmTokenUseCaseProvider),
    onRestored: () {
      ref.invalidate(homeViewModelProvider);
      ref.invalidate(eclassAssignmentListViewModelProvider);
      ref.invalidate(eclassLinkManagementViewModelProvider);
    },
  );
});
