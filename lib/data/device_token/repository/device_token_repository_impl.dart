import 'package:dongsoop/data/device_token/data_source/device_token_data_source.dart';
import 'package:dongsoop/data/device_token/data_source/fcm_token_data_source.dart';
import 'package:dongsoop/data/device_token/model/device_token_request.dart';
import 'package:dongsoop/domain/device_token/enum/failure_type.dart';
import 'package:dongsoop/domain/device_token/repositoy/device_token_repository.dart';

class DeviceTokenRepositoryImpl implements DeviceTokenRepository {
  final FcmTokenDataSource _fcm;
  final DeviceTokenDataSource _remote;

  DeviceTokenRepositoryImpl(this._fcm, this._remote);

  @override
  Future<void> init() => _fcm.init();

  @override
  Future<String?> getFcmToken() => _fcm.currentToken();

  @override
  Stream<String> tokenStreamWithInitial() => _fcm.tokenStreamWithInitial();

  @override
  Future<FailureType?> registerDeviceToken(DeviceTokenRequest request) async {
    bool allowed = false;
    try {
      allowed = await _fcm.requestPermissionIfNeeded();
    } catch (_) {
    }

    try {
      await _remote.registerDeviceToken(request);
      return allowed ? null : FailureType.permissionDenied;
    } catch (_) {
      return FailureType.registerFailed;
    }
  }
}