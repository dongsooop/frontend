import 'package:dongsoop/domain/device_token/use_case/get_fcm_token_use_case.dart';
import 'package:dongsoop/domain/device_token/use_case/get_fid_use_case.dart';
import 'package:dongsoop/domain/eclass/enum/eclass_link_restore_result.dart';
import 'package:dongsoop/domain/eclass/use_case/restore_expired_eclass_link_use_case.dart';

class EclassLinkRestoreController {
  final RestoreExpiredEclassLinkUseCase _restoreUseCase;
  final GetFidUseCase _getFidUseCase;
  final GetFcmTokenUseCase _getFcmTokenUseCase;
  final void Function() _onRestored;

  Future<EclassLinkRestoreResult>? _inFlight;

  EclassLinkRestoreController(
    this._restoreUseCase,
    this._getFidUseCase,
    this._getFcmTokenUseCase, {
    required void Function() onRestored,
  }) : _onRestored = onRestored;

  Future<EclassLinkRestoreResult> restoreIfExpired() async {
    final currentOperation = _inFlight;
    if (currentOperation != null) return currentOperation;

    final operation = _restore();
    _inFlight = operation;
    try {
      return await operation;
    } finally {
      if (identical(_inFlight, operation)) {
        _inFlight = null;
      }
    }
  }

  Future<EclassLinkRestoreResult> _restore() async {
    try {
      final identity = await _getDeviceIdentity();
      final result = await _restoreUseCase.execute(
        fid: identity.fid,
        deviceToken: identity.deviceToken,
      );
      if (result == EclassLinkRestoreResult.restored) {
        try {
          _onRestored();
        } catch (_) {}
      }
      return result;
    } catch (_) {
      return EclassLinkRestoreResult.failed;
    }
  }

  Future<({String? fid, String? deviceToken})> _getDeviceIdentity() async {
    final values = await Future.wait<String?>([
      _getFidUseCase.execute(),
      _getFcmTokenUseCase.execute(),
    ]);
    return (fid: values[0], deviceToken: values[1]);
  }
}
