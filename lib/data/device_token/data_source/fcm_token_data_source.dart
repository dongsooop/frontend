abstract class FcmTokenDataSource {
  Future<void> init();

  Future<void> dispose();

  Future<String?> currentToken();

  Stream<String> tokenStreamWithInitial();
}