import 'package:dongsoop/core/exception/eclass_exception.dart';
import 'package:dongsoop/domain/device_token/use_case/get_fcm_token_use_case.dart';
import 'package:dongsoop/domain/device_token/use_case/get_fid_use_case.dart';
import 'package:dongsoop/domain/eclass/entity/eclass_link_entity.dart';
import 'package:dongsoop/domain/eclass/use_case/delete_eclass_credentials_use_case.dart';
import 'package:dongsoop/domain/eclass/use_case/get_eclass_link_use_case.dart';
import 'package:dongsoop/domain/eclass/use_case/link_eclass_use_case.dart';
import 'package:dongsoop/domain/eclass/use_case/save_eclass_credentials_use_case.dart';
import 'package:dongsoop/domain/eclass/use_case/unlink_eclass_use_case.dart';
import 'package:dongsoop/presentation/eclass/link/view_model/eclass_link_management_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EclassLinkManagementViewModel
    extends StateNotifier<EclassLinkManagementState> {
  final GetEclassLinkUseCase _getEclassLinkUseCase;
  final LinkEclassUseCase _linkEclassUseCase;
  final UnlinkEclassUseCase _unlinkEclassUseCase;
  final SaveEclassCredentialsUseCase _saveEclassCredentialsUseCase;
  final DeleteEclassCredentialsUseCase _deleteEclassCredentialsUseCase;
  final GetFidUseCase _getFidUseCase;
  final GetFcmTokenUseCase _getFcmTokenUseCase;

  EclassLinkManagementViewModel(
    this._getEclassLinkUseCase,
    this._linkEclassUseCase,
    this._unlinkEclassUseCase,
    this._saveEclassCredentialsUseCase,
    this._deleteEclassCredentialsUseCase,
    this._getFidUseCase,
    this._getFcmTokenUseCase,
  ) : super(EclassLinkManagementState.initial());

  Future<void> load() async {
    state = state.copyWith(
      isInitialLoading: true,
      loadError: null,
      formError: null,
    );

    try {
      final identity = await _getDeviceIdentity();
      final link = await _getEclassLinkUseCase.execute(
        fid: identity.fid,
        deviceToken: identity.deviceToken,
      );
      state = state.copyWith(
        isInitialLoading: false,
        link: link,
        loadError: null,
      );
    } catch (error) {
      state = state.copyWith(
        isInitialLoading: false,
        link: null,
        loadError: _messageFor(
          error,
          'Eclass 연동 정보를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.',
        ),
      );
    }
  }

  Future<bool> link({
    required String eclassId,
    required String password,
  }) async {
    if (state.isBusy) return false;

    state = state.copyWith(
      isSubmitting: true,
      formError: null,
      actionError: null,
    );

    try {
      final identity = await _getDeviceIdentity();
      final linked = await _linkEclassUseCase.execute(
        eclassId: eclassId,
        password: password,
        fid: identity.fid,
        deviceToken: identity.deviceToken,
      );

      try {
        await _saveEclassCredentialsUseCase.execute(
          eclassId: eclassId,
          password: password,
        );
      } catch (_) {
        state = state.copyWith(
          isSubmitting: false,
          link: linked,
          actionError: 'Eclass 연동은 완료됐지만 자동 재연동 정보를 기기에 저장하지 못했어요. '
              '자동 재연동을 사용하려면 연동을 해제한 뒤 다시 연결해 주세요.',
        );
        return true;
      }

      state = state.copyWith(
        isSubmitting: false,
        link: linked,
        localCleanupRequired: false,
        formError: null,
      );
      return true;
    } on EclassInvalidCredentialsException catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        formError: error.message,
      );
      return false;
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        formError: _messageFor(
          error,
          'Eclass 연동에 실패했어요. 잠시 후 다시 시도해 주세요.',
        ),
      );
      return false;
    }
  }

  Future<void> unlink() async {
    if (state.isBusy) return;

    state = state.copyWith(
      isUnlinking: true,
      actionError: null,
      formError: null,
    );

    Object? remoteError;
    try {
      final identity = await _getDeviceIdentity();
      await _unlinkEclassUseCase.execute(
        fid: identity.fid,
        deviceToken: identity.deviceToken,
      );
    } catch (error) {
      remoteError = error;
    }

    Object? localError;
    try {
      await _deleteEclassCredentialsUseCase.execute();
    } catch (error) {
      localError = error;
    }

    if (remoteError == null) {
      state = state.copyWith(
        isUnlinking: false,
        link: const EclassLinkEntity(
          linked: false,
          status: null,
          moodleFullname: null,
          lastSyncedAt: null,
        ),
        localCleanupRequired: localError != null,
        actionError: localError == null
            ? null
            : 'Eclass 연동은 해제됐지만 기기에 저장된 자동 재연동 정보를 삭제하지 못했어요. '
                '아래 버튼을 눌러 다시 삭제해 주세요.',
      );
      return;
    }

    final remoteMessage = _messageFor(
      remoteError,
      'Eclass 연동 해제에 실패했어요. 잠시 후 다시 시도해 주세요.',
    );
    state = state.copyWith(
      isUnlinking: false,
      localCleanupRequired: localError != null,
      actionError: localError == null
          ? '$remoteMessage\n기기에 저장된 자동 재연동 정보는 삭제했어요.'
          : '$remoteMessage\n기기의 자동 재연동 정보도 삭제하지 못했어요.',
    );
  }

  Future<void> retryLocalCredentialDeletion() async {
    if (state.isBusy) return;

    state = state.copyWith(
      isDeletingLocalCredentials: true,
      actionError: null,
    );
    try {
      await _deleteEclassCredentialsUseCase.execute();
      state = state.copyWith(
        isDeletingLocalCredentials: false,
        localCleanupRequired: false,
      );
    } catch (_) {
      state = state.copyWith(
        isDeletingLocalCredentials: false,
        localCleanupRequired: true,
        actionError: '기기에 저장된 자동 재연동 정보를 삭제하지 못했어요. 잠시 후 다시 시도해 주세요.',
      );
    }
  }

  void clearFormError() {
    if (state.formError == null) return;
    state = state.copyWith(formError: null);
  }

  void clearActionError() {
    if (state.actionError == null) return;
    state = state.copyWith(actionError: null);
  }

  Future<({String? fid, String? deviceToken})> _getDeviceIdentity() async {
    final values = await Future.wait<String?>([
      _getFidUseCase.execute(),
      _getFcmTokenUseCase.execute(),
    ]);
    return (fid: values[0], deviceToken: values[1]);
  }

  String _messageFor(Object error, String fallback) {
    return error is EclassException ? error.message : fallback;
  }
}
