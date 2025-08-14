abstract class FcmTokenRepository {
  Future<void> init();
  Future<String?> getFcmToken();
  Stream<String> tokenStreamWithInitial();
}
