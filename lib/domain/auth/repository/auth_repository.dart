import 'package:dongsoop/domain/auth/model/login_response.dart';
import 'package:dongsoop/domain/auth/model/stored_user.dart';
import 'package:dongsoop/domain/auth/model/user.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(String email, String password);
  Future<void> logout();
  Future<void> saveUser(StoredUser storedUser);
  Future<User?> getUser();
  // change nickname
  // change password
  // change dept
}