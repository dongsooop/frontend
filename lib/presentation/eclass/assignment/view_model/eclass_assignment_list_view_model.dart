import 'package:dongsoop/core/exception/eclass_exception.dart';
import 'package:dongsoop/domain/device_token/use_case/get_fcm_token_use_case.dart';
import 'package:dongsoop/domain/device_token/use_case/get_fid_use_case.dart';
import 'package:dongsoop/domain/eclass/enum/eclass_link_status.dart';
import 'package:dongsoop/domain/eclass/use_case/get_eclass_assignments_use_case.dart';
import 'package:dongsoop/domain/eclass/use_case/sync_eclass_assignments_use_case.dart';
import 'package:dongsoop/presentation/eclass/assignment/view_model/eclass_assignment_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EclassAssignmentListViewModel
    extends StateNotifier<EclassAssignmentListState> {
  final GetEclassAssignmentsUseCase _getEclassAssignmentsUseCase;
  final SyncEclassAssignmentsUseCase _syncEclassAssignmentsUseCase;
  final GetFidUseCase _getFidUseCase;
  final GetFcmTokenUseCase _getFcmTokenUseCase;

  EclassAssignmentListViewModel(
    this._getEclassAssignmentsUseCase,
    this._syncEclassAssignmentsUseCase,
    this._getFidUseCase,
    this._getFcmTokenUseCase,
  ) : super(EclassAssignmentListState.initial());

  Future<void> load() async {
    state = state.copyWith(
      isInitialLoading: true,
      loadError: null,
      actionError: null,
    );

    try {
      final identity = await _getDeviceIdentity();
      final result = await _getEclassAssignmentsUseCase.execute(
        fid: identity.fid,
        deviceToken: identity.deviceToken,
      );
      state = state.copyWith(
        isInitialLoading: false,
        result: result,
        loadError: null,
      );
    } catch (error) {
      state = state.copyWith(
        isInitialLoading: false,
        result: null,
        loadError: _messageFor(
          error,
          'Eclass 과제를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.',
        ),
      );
    }
  }

  Future<void> refresh() async {
    if (state.isInitialLoading || state.isRefreshing) return;
    if (state.result == null) {
      await load();
      return;
    }

    state = state.copyWith(
      isRefreshing: true,
      actionError: null,
    );

    try {
      final identity = await _getDeviceIdentity();
      final current = state.result!;

      if (current.linked && current.status == EclassLinkStatus.active) {
        try {
          await _syncEclassAssignmentsUseCase.execute(
            fid: identity.fid,
            deviceToken: identity.deviceToken,
          );
        } on EclassNotLinkedException {
          // 다른 화면이나 기기에서 연동이 해제됐을 수 있으므로 아래에서 상태를 재조회한다.
        }
      }

      final result = await _getEclassAssignmentsUseCase.execute(
        fid: identity.fid,
        deviceToken: identity.deviceToken,
      );
      state = state.copyWith(
        isRefreshing: false,
        result: result,
      );
    } catch (error) {
      state = state.copyWith(
        isRefreshing: false,
        actionError: _messageFor(
          error,
          'Eclass 과제를 새로고침하지 못했어요. 잠시 후 다시 시도해 주세요.',
        ),
      );
    }
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
