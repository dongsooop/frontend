import 'package:dongsoop/domain/auth/model/sign_in_response.dart';
import 'package:dongsoop/domain/auth/model/sign_up_request.dart';
import 'package:dongsoop/domain/auth/model/stored_user.dart';
import 'package:dongsoop/domain/auth/model/user.dart';

abstract class AuthRepository {
  Future<SignInResponse> signIn(String email, String password);
  Future<void> logout();
  Future<void> saveUser(StoredUser storedUser);
  Future<User?> getUser();
  Future<void> signUp(SignUpRequest request);
  Future<bool> checkValidate(String data, String type);
  // change nickname
  // change password
  // change dept
}