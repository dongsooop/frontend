import 'package:dongsoop/domain/auth/model/sign_in_response.dart';
import 'package:dongsoop/domain/auth/model/sign_up_request.dart';
import 'package:dongsoop/domain/auth/model/stored_user.dart';
import 'package:dongsoop/domain/auth/model/user.dart';

abstract class AuthDataSource {
  Future<SignInResponse> signIn(String email, String password);
  Future<void> signUp(SignUpRequest request);
  Future<bool> passwordReset(String email, String password);
  Future<bool> passwordSendEmailCode(String userEmail);
  Future<bool> passwordCheckEmailCode(String userEmail, String code);
  Future<void> logout();
  Future<void> deleteUser();
  Future<User?> getUser();
  Future<void> saveUser(StoredUser storedUser);
  Future<bool> validate(String data, String type);
  Future<bool> checkEmailCode(String userEmail, String code);
  Future<bool> sendEmailCode(String userEmail);
  Future<void> userBlock(int blockerId, int blockedMemberId);
}