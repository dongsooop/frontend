import 'package:dongsoop/presentation/eclass/link/view_model/eclass_link_management_state.dart';
import 'package:dongsoop/presentation/eclass/link/view_model/eclass_link_management_view_model.dart';
import 'package:dongsoop/providers/device_providers.dart';
import 'package:dongsoop/providers/eclass_credentials_providers.dart';
import 'package:dongsoop/providers/eclass_link_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eclassLinkManagementViewModelProvider = StateNotifierProvider.autoDispose<
    EclassLinkManagementViewModel, EclassLinkManagementState>((ref) {
  return EclassLinkManagementViewModel(
    ref.watch(getEclassLinkUseCaseProvider),
    ref.watch(linkEclassUseCaseProvider),
    ref.watch(unlinkEclassUseCaseProvider),
    ref.watch(saveEclassCredentialsUseCaseProvider),
    ref.watch(deleteEclassCredentialsUseCaseProvider),
    ref.watch(getFidUseCaseProvider),
    ref.watch(getFcmTokenUseCaseProvider),
  );
});
