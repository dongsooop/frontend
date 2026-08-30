abstract class FcmTokenDataSource {
  Future<void> init();
  Future<void> dispose();
  Future<bool> hasPermission();
  Future<bool> requestPermissionIfNeeded();
  Future<String?> currentToken();
  Stream<String> tokenStreamWithInitial();

  /// Firebase Installation ID(FID) — deviceToken과 달리 로테이션되지 않는 안정 식별자.
  /// 실패해도 예외를 던지지 않고 null을 반환한다(등록 자체를 막지 않기 위함).
  Future<String?> currentFid();
}
