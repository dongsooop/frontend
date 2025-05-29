import 'package:dongsoop/domain/auth/model/login_response.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(String email, String password);
  // logout
  // change nickname
  // change password
  // change dept
}