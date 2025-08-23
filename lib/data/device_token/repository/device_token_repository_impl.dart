import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/device_token/data_source/device_token_data_source.dart';
import 'package:dongsoop/data/device_token/data_source/fcm_token_data_source.dart';
import 'package:dongsoop/data/device_token/model/device_token_request.dart';
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
  Future<void> registerDeviceToken(DeviceTokenRequest request) async {
    return _handle(() async {
      await _remote.registerDeviceToken(request);
    }, DeviceTokenRegisterException());
  }

  Future<T> _handle<T>(Future<T> Function() action, Exception exception) async {
    try {
      return await action();
    } catch (_) {
      throw exception;
    }
  }
}
