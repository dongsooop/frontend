import 'package:dongsoop/domain/eclass/entity/eclass_link_entity.dart';

const _notProvided = Object();

class EclassLinkManagementState {
  final bool isInitialLoading;
  final bool isSubmitting;
  final bool isUnlinking;
  final bool isDeletingLocalCredentials;
  final bool localCleanupRequired;
  final EclassLinkEntity? link;
  final String? loadError;
  final String? formError;
  final String? actionError;

  const EclassLinkManagementState({
    required this.isInitialLoading,
    required this.isSubmitting,
    required this.isUnlinking,
    required this.isDeletingLocalCredentials,
    required this.localCleanupRequired,
    required this.link,
    required this.loadError,
    required this.formError,
    required this.actionError,
  });

  factory EclassLinkManagementState.initial() {
    return const EclassLinkManagementState(
      isInitialLoading: true,
      isSubmitting: false,
      isUnlinking: false,
      isDeletingLocalCredentials: false,
      localCleanupRequired: false,
      link: null,
      loadError: null,
      formError: null,
      actionError: null,
    );
  }

  bool get isBusy => isSubmitting || isUnlinking || isDeletingLocalCredentials;

  EclassLinkManagementState copyWith({
    bool? isInitialLoading,
    bool? isSubmitting,
    bool? isUnlinking,
    bool? isDeletingLocalCredentials,
    bool? localCleanupRequired,
    Object? link = _notProvided,
    Object? loadError = _notProvided,
    Object? formError = _notProvided,
    Object? actionError = _notProvided,
  }) {
    return EclassLinkManagementState(
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isUnlinking: isUnlinking ?? this.isUnlinking,
      isDeletingLocalCredentials:
          isDeletingLocalCredentials ?? this.isDeletingLocalCredentials,
      localCleanupRequired: localCleanupRequired ?? this.localCleanupRequired,
      link:
          identical(link, _notProvided) ? this.link : link as EclassLinkEntity?,
      loadError: identical(loadError, _notProvided)
          ? this.loadError
          : loadError as String?,
      formError: identical(formError, _notProvided)
          ? this.formError
          : formError as String?,
      actionError: identical(actionError, _notProvided)
          ? this.actionError
          : actionError as String?,
    );
  }
}
