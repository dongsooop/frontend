import 'package:dongsoop/domain/fcm_token/repository/fcm_token_repository.dart';
import '../data_source/fcm_token_data_source.dart';

class FcmTokenRepositoryImpl implements FcmTokenRepository {
  final FcmTokenDataSource _dataSource;
  FcmTokenRepositoryImpl(this._dataSource);

  @override
  Future<void> init() => _dataSource.init();

  @override
  Future<String?> getFcmToken() => _dataSource.currentToken();

  // 초기 토큰 1회 + 이후 갱신을 하나의 스트림으로 제공
  @override
  Stream<String> tokenStreamWithInitial() => _dataSource.tokenStreamWithInitial();
}
