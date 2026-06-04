abstract class FcmTokenDataSource {
  Future<void> init();
  Future<void> dispose();
  Future<bool> hasPermission();
  Future<bool> requestPermissionIfNeeded();
  Future<String?> currentToken();
  Stream<String> tokenStreamWithInitial();
}
