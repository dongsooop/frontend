import 'package:dongsoop/domain/auth/model/login_response.dart';
import 'package:dongsoop/domain/auth/model/user.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(String email, String password);
  // logout
  // change nickname
  // change password
  // change dept

  // 사용자 정보 로컬 저장, 조회, 삭제
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> clearUser();
}