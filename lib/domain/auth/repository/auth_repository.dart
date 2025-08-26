import 'package:dongsoop/domain/auth/model/sign_in_response.dart';
import 'package:dongsoop/domain/auth/model/sign_up_request.dart';
import 'package:dongsoop/domain/auth/model/stored_user.dart';
import 'package:dongsoop/domain/auth/model/user.dart';

abstract class AuthRepository {
  Future<SignInResponse> signIn(String email, String password, String fcmToken);
  Future<void> logout();
  Future<bool> passwordReset(String email, String password);
  Future<bool> passwordSendEmailCode(String userEmail);
  Future<bool> passwordCheckEmailCode(String userEmail, String code);
  Future<void> deleteUser();
  Future<void> saveUser(StoredUser storedUser);
  Future<User?> getUser();
  Future<void> signUp(SignUpRequest request);
  Future<bool> checkValidate(String data, String type);
  Future<bool> checkEmailCode(String userEmail, String code);
  Future<bool> sendEmailCode(String userEmail);
  Future<void> userBlock(int blockerId, int blockedMemberId);
}