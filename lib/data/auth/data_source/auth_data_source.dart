import 'package:dongsoop/domain/auth/model/login_response.dart';
import 'package:dongsoop/domain/auth/model/stored_user.dart';
import 'package:dongsoop/domain/auth/model/user.dart';

abstract class AuthDataSource {
  Future<LoginResponse> login(String email, String password);
  Future<void> logout();
  Future<User?> getUser();
  Future<void> saveUser(StoredUser storedUser);
}